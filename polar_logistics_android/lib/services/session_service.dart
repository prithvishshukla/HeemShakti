import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

/// Minimal, non-sensitive session data restored on app startup.
/// Deliberately excludes the password / password hash.
class SessionData {
  final String userId;
  final String username;
  final UserRole role;

  const SessionData({
    required this.userId,
    required this.username,
    required this.role,
  });
}

// ============================================================
// SESSION SERVICE
// ------------------------------------------------------------
// Persists only safe session metadata (user id, username, role)
// using SharedPreferences. SharedPreferences is used here strictly
// as lightweight session metadata storage - never as the primary
// store for user records or password data, which live in
// UserRepository (Hive) instead.
// ============================================================
class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  static const _keyUserId = 'polar_session_user_id';
  static const _keyUsername = 'polar_session_username';
  static const _keyRole = 'polar_session_role';

  Future<void> saveSession(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUsername, user.username);
    await prefs.setString(_keyRole, user.role.name);
  }

  Future<SessionData?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    final username = prefs.getString(_keyUsername);
    final roleStr = prefs.getString(_keyRole);
    if (userId == null || username == null || roleStr == null) {
      return null;
    }
    return SessionData(
      userId: userId,
      username: username,
      role: UserRoleX.fromString(roleStr),
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyRole);
  }
}
