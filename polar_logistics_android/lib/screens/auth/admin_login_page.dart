import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/login_field.dart';
import '../admin/admin_dashboard.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// NCPOR / ADMIN LOGIN
// ------------------------------------------------------------
// Authenticates exclusively through AuthService.loginAdmin, which in
// turn only accepts accounts with UserRole.admin. There is no
// hardcoded credential check in this widget.
// ============================================================
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final result = await AuthService.instance.loginAdmin(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Login failed.')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('NCPOR / Admin Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: polarDark,
                ),
                const SizedBox(height: 20),
                const Text(
                  'NCPOR / ADMIN',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: polarDeep,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'National Centre for Polar and Ocean Research',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: polarBlue, fontSize: 14),
                ),
                const SizedBox(height: 40),
                LoginField(
                  controller: usernameController,
                  label: 'Username / NCPOR ID',
                  icon: Icons.person,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                LoginField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  showVisibilityToggle: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: polarBlue,
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
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Authorized NCPOR personnel only',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
