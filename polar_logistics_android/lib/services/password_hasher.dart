import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

// ============================================================
// PASSWORD HASHER
// ------------------------------------------------------------
// Passwords are NEVER stored or logged in plain text.
//
// Each password is hashed with a unique, randomly generated salt
// using SHA-256, plus a fixed application-level pepper as a second
// layer of defense. The result is persisted as a single string in
// the form "<salt>:<hash>" inside AppUser.passwordHash.
//
// This keeps the prototype dependency-light (the `crypto` package
// is a pure-Dart, actively maintained Google package with no native
// build requirements) while avoiding plain-text or reversible
// password storage entirely.
// ============================================================
class PasswordHasher {
  PasswordHasher._();

  // Application-level pepper. This is NOT a substitute for the
  // per-user random salt below - it is an additional constant mixed
  // into every hash. In a production deployment this should be
  // moved to a secure build-time configuration value rather than
  // committed to source control.
  static const String _pepper = 'polar-logistics-ncpor-antarctic-ops';

  /// Generates a new cryptographically random salt for a single user.
  static String generateSalt({int length = 16}) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  /// Hashes [password] with the given [salt].
  static String _hash(String password, String salt) {
    final bytes = utf8.encode('$salt::$password::$_pepper');
    return sha256.convert(bytes).toString();
  }

  /// Creates a new combined "<salt>:<hash>" string for a fresh password.
  /// Use this when creating a user or resetting a password.
  static String createHash(String password) {
    final salt = generateSalt();
    final hash = _hash(password, salt);
    return '$salt:$hash';
  }

  /// Verifies [password] against a stored "<salt>:<hash>" value.
  static bool verify(String password, String storedSaltAndHash) {
    final parts = storedSaltAndHash.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final expectedHash = parts[1];
    final actualHash = _hash(password, salt);
    return _constantTimeEquals(actualHash, expectedHash);
  }

  /// Constant-time string comparison to reduce timing-attack surface.
  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
