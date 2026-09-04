import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';
import '../services/password_hasher.dart';

/// Thrown for user-management failures that should be shown to the
/// Admin as a friendly message (e.g. duplicate Personnel ID).
class UserRepositoryException implements Exception {
  final String message;
  UserRepositoryException(this.message);

  @override
  String toString() => message;
}

// ============================================================
// USER REPOSITORY
// ------------------------------------------------------------
// Local persistence for authentication accounts, backed by Hive
// (a fast, pure-Dart local NoSQL store with no native SQL bindings
// to manage - a good fit for this prototype).
//
// Every user record is stored as a plain Map inside a single Hive
// box, keyed by the user's id. This deliberately avoids Hive's
// generated TypeAdapter/build_runner workflow to keep the project
// buildable without a codegen step.
//
// BACKEND MIGRATION PATH
// ------------------------------------------------------------
// All screens and services only ever talk to UserRepository's public
// methods (never to Hive directly). To later swap in a FastAPI
// backend, create a `RestUserRepository` implementing the same
// method signatures used here (findByUsername, createExpeditionUser,
// updateUser, setActiveStatus, resetPassword, getAllUsers, getById)
// and swap the singleton instance - no UI or AuthService changes
// required.
// ============================================================
class UserRepository {
  UserRepository._();

  static final UserRepository instance = UserRepository._();

  static const String _boxName = 'polar_users_box';

  Box? _box;

  bool get isInitialized => _box != null && _box!.isOpen;

  /// Opens the local user store and seeds the initial Admin account
  /// the very first time the app runs on a device. Must be awaited
  /// once, before runApp(), from main().
  Future<void> init() async {
    if (isInitialized) return;
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    await _seedAdminIfNeeded();
  }

  Box get _usersBox {
    final box = _box;
    if (box == null || !box.isOpen) {
      throw StateError(
        'UserRepository not initialized. Call UserRepository.instance.init() '
        'before using it (this is done once in main()).',
      );
    }
    return box;
  }

  // ============================================================
  // ADMIN BOOTSTRAP
  // ------------------------------------------------------------
  // This is the ONLY place the initial NCPOR Administrator account
  // is created. It is seeded exactly once - the first time the app
  // runs on a device (i.e. whenever the local user store is empty of
  // any Admin account). No hardcoded credential checks exist anywhere
  // else in the app; every login goes through AuthService, which in
  // turn checks this repository.
  //
  //   Default bootstrap credentials:
  //     Username : admin
  //     Password : Ncpor@2026
  //
  // BEFORE PRODUCTION USE:
  //   1. Log in with the credentials above immediately after first
  //      install on an NCPOR device.
  //   2. Change the password via Admin login using a password-reset
  //      flow (or call UserRepository.instance.resetPassword with the
  //      seeded admin's id) before the device is used operationally.
  //   3. To support multiple Admin accounts in future, this
  //      repository already supports it structurally (role is just a
  //      field on AppUser) - only the current "Manage Expedition
  //      Users" screen restricts creation to expedition accounts. A
  //      future "Manage Admins" screen could call the same
  //      createUser-style logic with UserRole.admin.
  // ============================================================
  Future<void> _seedAdminIfNeeded() async {
    final hasAdmin = _usersBox.values.any(
      (raw) => Map<String, dynamic>.from(raw as Map)['role'] ==
          UserRole.admin.name,
    );
    if (hasAdmin) return;

    final admin = AppUser(
      id: const Uuid().v4(),
      fullName: 'NCPOR System Administrator',
      username: 'admin',
      passwordHash: PasswordHasher.createHash('Ncpor@2026'),
      role: UserRole.admin,
      isActive: true,
      createdAt: DateTime.now(),
    );
    await _usersBox.put(admin.id, admin.toMap());
  }

  AppUser _decode(dynamic raw) =>
      AppUser.fromMap(Map<String, dynamic>.from(raw as Map));

  Future<AppUser?> findByUsername(String username) async {
    final target = username.trim().toLowerCase();
    for (final raw in _usersBox.values) {
      final user = _decode(raw);
      if (user.username.toLowerCase() == target) return user;
    }
    return null;
  }

  Future<bool> usernameExists(String username, {String? excludingId}) async {
    final existing = await findByUsername(username);
    if (existing == null) return false;
    if (excludingId != null && existing.id == excludingId) return false;
    return true;
  }

  Future<AppUser?> getById(String id) async {
    final raw = _usersBox.get(id);
    if (raw == null) return null;
    return _decode(raw);
  }

  /// Returns all users, optionally filtered by [role], newest first.
  Future<List<AppUser>> getAllUsers({UserRole? role}) async {
    final all = _usersBox.values.map(_decode).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (role == null) return all;
    return all.where((u) => u.role == role).toList();
  }

  /// Creates a new Expedition Team account. Only ever called from
  /// Admin-only screens after an authenticated Admin session has
  /// been verified.
  Future<AppUser> createExpeditionUser({
    required String fullName,
    required String username,
    required String password,
    required PersonnelRole personnelRole,
    String? expeditionId,
  }) async {
    final cleanUsername = username.trim();
    if (await usernameExists(cleanUsername)) {
      throw UserRepositoryException(
        'A user with this Personnel ID already exists.',
      );
    }

    final user = AppUser(
      id: const Uuid().v4(),
      fullName: fullName.trim(),
      username: cleanUsername,
      passwordHash: PasswordHasher.createHash(password),
      role: UserRole.expedition,
      personnelRole: personnelRole,
      expeditionId: (expeditionId != null && expeditionId.trim().isNotEmpty)
          ? expeditionId.trim()
          : null,
      isActive: true,
      createdAt: DateTime.now(),
    );

    await _usersBox.put(user.id, user.toMap());
    return user;
  }

  /// Updates profile fields (name, username, personnel role,
  /// expedition id). Does NOT touch the password or active status -
  /// use [resetPassword] / [setActiveStatus] for those.
  Future<AppUser> updateUser({
    required String id,
    required String fullName,
    required String username,
    required PersonnelRole? personnelRole,
    String? expeditionId,
  }) async {
    final existing = await getById(id);
    if (existing == null) {
      throw UserRepositoryException('User not found.');
    }

    final cleanUsername = username.trim();
    if (existing.username.toLowerCase() != cleanUsername.toLowerCase() &&
        await usernameExists(cleanUsername, excludingId: id)) {
      throw UserRepositoryException(
        'A user with this Personnel ID already exists.',
      );
    }

    final updated = existing.copyWith(
      fullName: fullName.trim(),
      username: cleanUsername,
      personnelRole: personnelRole,
      expeditionId: expeditionId,
      clearExpeditionId: expeditionId == null || expeditionId.trim().isEmpty,
      updatedAt: DateTime.now(),
    );

    await _usersBox.put(updated.id, updated.toMap());
    return updated;
  }

  /// Activates or deactivates a user. Deactivated users can never
  /// log in, regardless of a still-valid local session (see
  /// AuthService.getValidatedUser / restoreSession).
  Future<AppUser> setActiveStatus(String id, bool isActive) async {
    final existing = await getById(id);
    if (existing == null) {
      throw UserRepositoryException('User not found.');
    }
    final updated = existing.copyWith(
      isActive: isActive,
      updatedAt: DateTime.now(),
    );
    await _usersBox.put(updated.id, updated.toMap());
    return updated;
  }

  /// Sets a brand new password hash for a user. The old password is
  /// never read back or displayed - this simply overwrites the hash.
  Future<AppUser> resetPassword(String id, String newPassword) async {
    final existing = await getById(id);
    if (existing == null) {
      throw UserRepositoryException('User not found.');
    }
    final updated = existing.copyWith(
      passwordHash: PasswordHasher.createHash(newPassword),
      updatedAt: DateTime.now(),
    );
    await _usersBox.put(updated.id, updated.toMap());
    return updated;
  }
}
