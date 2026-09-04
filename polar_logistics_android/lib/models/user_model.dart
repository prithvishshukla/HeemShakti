// ============================================================
// USER MODEL
// ------------------------------------------------------------
// Central identity model for Polar Logistics authentication.
//
// AppUser represents an AUTHENTICATION ACCOUNT (login identity),
// intentionally kept separate from any richer "Personnel profile"
// that may exist elsewhere in the app (see screens/admin/personnel_page.dart).
// This separation means the login system can evolve independently
// of how personnel records are displayed/managed elsewhere.
//
//   Authentication Account (AppUser)  ---->  Personnel Profile (future link)
//
// Only password HASHES are ever stored on an AppUser - raw
// passwords are never persisted, logged, or displayed anywhere.
// ============================================================

/// Top level access role. Only two values exist in this system:
/// - [admin]      : NCPOR / Admin users. Full access to Admin Dashboard.
/// - [expedition]  : Expedition Team members. Access to Expedition Dashboard only.
enum UserRole {
  admin,
  expedition,
}

extension UserRoleX on UserRole {
  /// Human readable label used in the UI.
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'NCPOR Administrator';
      case UserRole.expedition:
        return 'Expedition Member';
    }
  }

  /// Parses a role from its persisted string form (enum name).
  /// Defaults to [UserRole.expedition] for unknown/corrupt values so
  /// that a bad record can never silently become an Admin account.
  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.expedition,
    );
  }
}

/// Personnel-facing role for Expedition Team members. Reuses the kind
/// of role labels already used informally in the existing Personnel
/// section (e.g. "Logistics Officer", "Research Scientist") so the new
/// account system feels native to the rest of the app.
enum PersonnelRole {
  expeditionLeader,
  scientist,
  logisticsOfficer,
  engineer,
  medicalOfficer,
  crewMember,
  other,
}

extension PersonnelRoleX on PersonnelRole {
  String get label {
    switch (this) {
      case PersonnelRole.expeditionLeader:
        return 'Expedition Leader';
      case PersonnelRole.scientist:
        return 'Scientist';
      case PersonnelRole.logisticsOfficer:
        return 'Logistics Officer';
      case PersonnelRole.engineer:
        return 'Engineer';
      case PersonnelRole.medicalOfficer:
        return 'Medical Officer';
      case PersonnelRole.crewMember:
        return 'Crew Member';
      case PersonnelRole.other:
        return 'Other';
    }
  }

  static PersonnelRole fromString(String? value) {
    return PersonnelRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PersonnelRole.crewMember,
    );
  }
}

/// A single authentication account, either an NCPOR Admin or an
/// Expedition Team member created by an Admin.
class AppUser {
  final String id;
  final String fullName;

  /// Login identifier. For Admin accounts this is a username; for
  /// Expedition accounts this is treated as the Personnel ID.
  final String username;

  /// Stored as "<salt>:<sha256 hash>". Never a raw password.
  final String passwordHash;

  final UserRole role;

  /// Only meaningful for [UserRole.expedition] accounts.
  final PersonnelRole? personnelRole;

  /// Optional expedition assignment (free-form ID/code), only used
  /// for Expedition accounts.
  final String? expeditionId;

  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.username,
    required this.passwordHash,
    required this.role,
    this.personnelRole,
    this.expeditionId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  AppUser copyWith({
    String? fullName,
    String? username,
    String? passwordHash,
    PersonnelRole? personnelRole,
    String? expeditionId,
    bool clearExpeditionId = false,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role,
      personnelRole: personnelRole ?? this.personnelRole,
      expeditionId:
          clearExpeditionId ? null : (expeditionId ?? this.expeditionId),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'passwordHash': passwordHash,
      'role': role.name,
      'personnelRole': personnelRole?.name,
      'expeditionId': expeditionId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      username: map['username'] as String,
      passwordHash: map['passwordHash'] as String,
      role: UserRoleX.fromString(map['role'] as String?),
      personnelRole: map['personnelRole'] != null
          ? PersonnelRoleX.fromString(map['personnelRole'] as String?)
          : null,
      expeditionId: map['expeditionId'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
              DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }
}
