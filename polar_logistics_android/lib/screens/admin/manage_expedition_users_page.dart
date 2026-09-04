import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// MANAGE EXPEDITION USERS (Admin-only)
// ------------------------------------------------------------
// Reached only from AdminDashboard, which itself is wrapped in
// AuthGate(requiredRole: UserRole.admin). This screen is where an
// authenticated Admin creates, views, edits, and activates or
// deactivates Expedition Team login accounts. Expedition users have
// no path to reach this screen or any of its actions.
// ============================================================
class ManageExpeditionUsersPage extends StatefulWidget {
  const ManageExpeditionUsersPage({super.key});

  @override
  State<ManageExpeditionUsersPage> createState() =>
      _ManageExpeditionUsersPageState();
}

class _ManageExpeditionUsersPageState
    extends State<ManageExpeditionUsersPage> {
  final UserRepository _repo = UserRepository.instance;
  List<AppUser> _users = [];
  bool _isLoading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _repo.getAllUsers(role: UserRole.expedition);
    if (!mounted) return;
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  List<AppUser> get _filteredUsers {
    if (_query.trim().isEmpty) return _users;
    final q = _query.trim().toLowerCase();
    return _users.where((u) {
      return u.fullName.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openCreatePage() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateExpeditionUserPage()),
    );
    if (created == true) _loadUsers();
  }

  Future<void> _openEditPage(AppUser user) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditExpeditionUserPage(user: user)),
    );
    if (updated == true) _loadUsers();
  }

  Future<void> _toggleActive(AppUser user) async {
    final activating = !user.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(activating ? 'Activate User?' : 'Deactivate User?'),
        content: Text(
          activating
              ? '${user.fullName} will be able to log in again.'
              : '${user.fullName} will no longer be able to log in until reactivated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: activating ? Colors.green : Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(activating ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _repo.setActiveStatus(user.id, activating);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          activating
              ? 'User activated successfully.'
              : 'User deactivated successfully.',
        ),
      ),
    );
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Manage Expedition Users'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUsers,
        color: polarBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expedition User Accounts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: polarDeep,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Create and manage login accounts for expedition personnel',
                style: TextStyle(color: polarBlue),
              ),
              const SizedBox(height: 20),

              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search by name or Personnel ID',
                  prefixIcon: const Icon(Icons.search, color: polarBlue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: polarLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: polarLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: polarBlue, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: CircularProgressIndicator(color: polarBlue),
                  ),
                )
              else if (_filteredUsers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 56,
                          color: polarLight,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _users.isEmpty
                              ? 'No expedition users yet.\nTap + to create one.'
                              : 'No users match your search.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._filteredUsers.map(
                  (user) => _ExpeditionUserCard(
                    user: user,
                    onTap: () => _openEditPage(user),
                    onToggleActive: () => _toggleActive(user),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: polarDark,
        foregroundColor: Colors.white,
        onPressed: _openCreatePage,
        tooltip: 'Create Expedition User',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

// ============================================================
// EXPEDITION USER CARD
// ============================================================
class _ExpeditionUserCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;
  final VoidCallback onToggleActive;

  const _ExpeditionUserCard({
    required this.user,
    required this.onTap,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final roleLabel = user.personnelRole?.label ?? 'Crew Member';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: polarLight),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: polarVeryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.person, color: polarDark, size: 28),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${user.username}\n$roleLabel'
            '${user.expeditionId != null ? '\nExpedition: ${user.expeditionId}' : ''}',
          ),
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: user.isActive
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.redAccent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: user.isActive ? Colors.green : Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 8),
            IconButton(
              icon: Icon(
                user.isActive ? Icons.toggle_on : Icons.toggle_off,
                color: user.isActive ? Colors.green : Colors.grey,
                size: 30,
              ),
              tooltip: user.isActive ? 'Deactivate' : 'Activate',
              onPressed: onToggleActive,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CREATE EXPEDITION USER
// ============================================================
class CreateExpeditionUserPage extends StatefulWidget {
  const CreateExpeditionUserPage({super.key});

  @override
  State<CreateExpeditionUserPage> createState() =>
      _CreateExpeditionUserPageState();
}

class _CreateExpeditionUserPageState extends State<CreateExpeditionUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _expeditionIdController = TextEditingController();

  PersonnelRole? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _expeditionIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await UserRepository.instance.createExpeditionUser(
        fullName: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        personnelRole: _selectedRole!,
        expeditionId: _expeditionIdController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expedition user created successfully.')),
      );
      Navigator.pop(context, true);
    } on UserRepositoryException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Create Expedition User'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel('Full Name'),
                _StyledTextField(
                  controller: _nameController,
                  icon: Icons.badge_outlined,
                  hint: 'e.g. Kavya Singh',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Full name is required.'
                      : null,
                ),
                const SizedBox(height: 18),

                _FieldLabel('Personnel ID / Username'),
                _StyledTextField(
                  controller: _usernameController,
                  icon: Icons.person_outline,
                  hint: 'e.g. NPC-007',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Personnel ID is required.'
                      : null,
                ),
                const SizedBox(height: 18),

                _FieldLabel('Role'),
                _StyledDropdown(
                  value: _selectedRole,
                  hint: 'Select role',
                  onChanged: (role) => setState(() => _selectedRole = role),
                ),
                const SizedBox(height: 18),

                _FieldLabel('Expedition ID (optional)'),
                _StyledTextField(
                  controller: _expeditionIdController,
                  icon: Icons.explore_outlined,
                  hint: 'e.g. Antarctic Expedition 2026',
                ),
                const SizedBox(height: 18),

                _FieldLabel('Password'),
                _StyledTextField(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hint: 'Minimum 6 characters',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: polarBlue,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password is required.';
                    }
                    if (v.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                _FieldLabel('Confirm Password'),
                _StyledTextField(
                  controller: _confirmPasswordController,
                  icon: Icons.lock_outline,
                  hint: 'Re-enter password',
                  obscureText: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: polarBlue,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please confirm the password.';
                    }
                    if (v != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: polarDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'CREATE USER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EDIT EXPEDITION USER
// ============================================================
class EditExpeditionUserPage extends StatefulWidget {
  final AppUser user;

  const EditExpeditionUserPage({super.key, required this.user});

  @override
  State<EditExpeditionUserPage> createState() =>
      _EditExpeditionUserPageState();
}

class _EditExpeditionUserPageState extends State<EditExpeditionUserPage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _expeditionIdController;
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  late PersonnelRole? _selectedRole;
  late bool _isActive;
  bool _isSavingProfile = false;
  bool _isUpdatingPassword = false;
  bool _isTogglingActive = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _usernameController = TextEditingController(text: widget.user.username);
    _expeditionIdController =
        TextEditingController(text: widget.user.expeditionId ?? '');
    _selectedRole = widget.user.personnelRole;
    _isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _expeditionIdController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!(_profileFormKey.currentState?.validate() ?? false)) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role.')),
      );
      return;
    }

    setState(() => _isSavingProfile = true);
    try {
      await UserRepository.instance.updateUser(
        id: widget.user.id,
        fullName: _nameController.text,
        username: _usernameController.text,
        personnelRole: _selectedRole,
        expeditionId: _expeditionIdController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully.')),
      );
      Navigator.pop(context, true);
    } on UserRepositoryException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _isSavingProfile = false);
    }
  }

  Future<void> _updatePassword() async {
    if (!(_passwordFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isUpdatingPassword = true);
    try {
      await UserRepository.instance.resetPassword(
        widget.user.id,
        _newPasswordController.text,
      );
      if (!mounted) return;
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully.')),
      );
    } on UserRepositoryException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _isUpdatingPassword = false);
    }
  }

  Future<void> _toggleActive() async {
    final activating = !_isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(activating ? 'Activate User?' : 'Deactivate User?'),
        content: Text(
          activating
              ? '${widget.user.fullName} will be able to log in again.'
              : '${widget.user.fullName} will no longer be able to log in until reactivated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: activating ? Colors.green : Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(activating ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isTogglingActive = true);
    try {
      await UserRepository.instance.setActiveStatus(
        widget.user.id,
        activating,
      );
      if (!mounted) return;
      setState(() {
        _isActive = activating;
        _isTogglingActive = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            activating
                ? 'User activated successfully.'
                : 'User deactivated successfully.',
          ),
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _isTogglingActive = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Edit Expedition User'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // STATUS BANNER
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: polarLight),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isActive ? Icons.check_circle : Icons.cancel,
                      color: _isActive ? Colors.green : Colors.redAccent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isActive
                            ? 'This account is Active and can log in.'
                            : 'This account is Inactive and cannot log in.',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: polarDeep,
                        ),
                      ),
                    ),
                    _isTogglingActive
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : OutlinedButton(
                            onPressed: _toggleActive,
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  _isActive ? Colors.redAccent : Colors.green,
                              side: BorderSide(
                                color: _isActive
                                    ? Colors.redAccent
                                    : Colors.green,
                              ),
                            ),
                            child: Text(_isActive ? 'Deactivate' : 'Activate'),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              const Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: polarDeep,
                ),
              ),
              const SizedBox(height: 15),

              Form(
                key: _profileFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Full Name'),
                    _StyledTextField(
                      controller: _nameController,
                      icon: Icons.badge_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Full name is required.'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel('Personnel ID / Username'),
                    _StyledTextField(
                      controller: _usernameController,
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Personnel ID is required.'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel('Role'),
                    _StyledDropdown(
                      value: _selectedRole,
                      hint: 'Select role',
                      onChanged: (role) =>
                          setState(() => _selectedRole = role),
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel('Expedition ID (optional)'),
                    _StyledTextField(
                      controller: _expeditionIdController,
                      icon: Icons.explore_outlined,
                    ),
                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSavingProfile ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: polarBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSavingProfile
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'SAVE CHANGES',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: polarDeep,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'The existing password is never shown. Setting a new '
                'password immediately replaces it.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 15),

              Form(
                key: _passwordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('New Password'),
                    _StyledTextField(
                      controller: _newPasswordController,
                      icon: Icons.lock_outline,
                      hint: 'Minimum 6 characters',
                      obscureText: _obscureNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: polarBlue,
                        ),
                        onPressed: () => setState(
                          () => _obscureNewPassword = !_obscureNewPassword,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'New password is required.';
                        }
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    _FieldLabel('Confirm New Password'),
                    _StyledTextField(
                      controller: _confirmNewPasswordController,
                      icon: Icons.lock_outline,
                      hint: 'Re-enter new password',
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: polarBlue,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please confirm the new password.';
                        }
                        if (v != _newPasswordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed:
                            _isUpdatingPassword ? null : _updatePassword,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: polarDeep,
                          side: const BorderSide(color: polarDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isUpdatingPassword
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: polarDark,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'UPDATE PASSWORD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SHARED FORM HELPERS (local to user-management screens)
// ============================================================
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: polarDeep,
        ),
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _StyledTextField({
    required this.controller,
    required this.icon,
    this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: polarBlue),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: polarLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: polarBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}

class _StyledDropdown extends StatelessWidget {
  final PersonnelRole? value;
  final String hint;
  final ValueChanged<PersonnelRole?> onChanged;

  const _StyledDropdown({
    required this.value,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PersonnelRole>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down, color: polarBlue),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.work_outline, color: polarBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: polarLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: polarBlue, width: 2),
        ),
      ),
      items: PersonnelRole.values
          .map(
            (role) => DropdownMenuItem(
              value: role,
              child: Text(role.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
