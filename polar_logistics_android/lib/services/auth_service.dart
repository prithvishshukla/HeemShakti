import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'password_hasher.dart';
import 'session_service.dart';


/// Result of a login attempt. UI code should only ever branch on
/// [success] and show [message] - no login widget ever inspects
/// credentials or role logic directly.
class AuthResult {
  final bool success;
  final String? message;
  final AppUser? user;

  const AuthResult._({required this.success, this.message, this.user});

  factory AuthResult.success(AppUser user) =>
      AuthResult._(success: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult._(success: false, message: message);
}

// ============================================================
// AUTH SERVICE
// ------------------------------------------------------------
// Single source of truth for authentication. Every login screen and
// every protected screen goes through this service - there are no
// hardcoded username/password checks anywhere else in the app.
//
// Responsibilities:
//   - Verify credentials against UserRepository (hashed passwords).
//   - Enforce role separation (Admin login only authenticates Admin
//     accounts, Expedition login only authenticates Expedition
//     accounts).
//   - Reject inactive/deactivated accounts.
//   - Persist and validate sessions via SessionService.
//
// BACKEND MIGRATION PATH
// ------------------------------------------------------------
// When a FastAPI backend is introduced, this class is the only place
// that needs to change: replace the UserRepository calls below with
// HTTP calls to the backend (e.g. POST /auth/login), while keeping
// the same method signatures (loginAdmin/loginExpedition/logout/
// getValidatedUser/restoreSession). No UI code would need to change.
// ============================================================
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final UserRepository _repo = UserRepository.instance;
  final SessionService _session = SessionService.instance;

  Future<AuthResult> loginAdmin({
    required String username,
    required String password,
  }) {
    return _login(
      username: username,
      password: password,
      expectedRole: UserRole.admin,
    );
  }

  Future<AuthResult> loginExpedition({
    required String username,
    required String password,
  }) {
    return _login(
      username: username,
      password: password,
      expectedRole: UserRole.expedition,
    );
  }

  Future<AuthResult> _login({
    required String username,
    required String password,
    required UserRole expectedRole,
  }) async {
    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty || password.isEmpty) {
      return AuthResult.failure('Please enter username and password.');
    }

    final user = await _repo.findByUsername(trimmedUsername);

    // Unknown username OR a real account of the wrong role (e.g. an
    // Expedition user attempting to use the Admin login form) both
    // return the same generic message, so the login form never
    // reveals which part of the credential pair was wrong or
    // whether an account exists under a different role.
    if (user == null || user.role != expectedRole) {
      return AuthResult.failure('Invalid Personnel ID or password.');
    }

    if (!user.isActive) {
      return AuthResult.failure(
        'This account has been deactivated. Please contact the administrator.',
      );
    }

    final passwordValid = PasswordHasher.verify(password, user.passwordHash);
    if (!passwordValid) {
      return AuthResult.failure('Invalid Personnel ID or password.');
    }

    await _session.saveSession(user);
    return AuthResult.success(user);
  }

  /// Clears the current session. Callers are responsible for
  /// navigating back to the appropriate entry screen afterwards.
  Future<void> logout() async {
    await _session.clearSession();
  }

  /// Used once at app startup to silently restore whichever session
  /// (Admin or Expedition) is currently valid. Returns null if there
  /// is no session, or if the underlying account no longer exists or
  /// has been deactivated since the session was created (in which
  /// case the stale session is cleared).
  Future<AppUser?> restoreSession() async {
    final session = await _session.loadSession();
    if (session == null) return null;

    final user = await _repo.getById(session.userId);
    if (user == null || !user.isActive) {
      await _session.clearSession();
      return null;
    }
    return user;
  }

  /// Validates the current session for a screen that requires a
  /// specific [requiredRole]. Re-checks the account against the
  /// repository every time (not just the cached session), so an
  /// Admin deactivating an Expedition user takes effect immediately
  /// the next time that user's app tries to open a protected screen.
  /// Returns null (and clears an invalid session) if access should
  /// be denied.
  Future<AppUser?> getValidatedUser({required UserRole requiredRole}) async {
    final session = await _session.loadSession();
    if (session == null) return null;
    if (session.role != requiredRole) return null;

    final user = await _repo.getById(session.userId);
    if (user == null || !user.isActive || user.role != requiredRole) {
      await _session.clearSession();
      return null;
    }
    return user;
  }
}
