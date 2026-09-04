import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/login_field.dart';
import '../expedition/expedition_dashboard.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// EXPEDITION TEAM LOGIN
// ------------------------------------------------------------
// Authenticates exclusively through AuthService.loginExpedition,
// which only accepts accounts with UserRole.expedition that were
// created by an Admin. There is no self-registration path anywhere
// in this screen or the app.
// ============================================================
class ExpeditionLoginPage extends StatefulWidget {
  const ExpeditionLoginPage({super.key});

  @override
  State<ExpeditionLoginPage> createState() => _ExpeditionLoginPageState();
}

class _ExpeditionLoginPageState extends State<ExpeditionLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final result = await AuthService.instance.loginExpedition(
      username: usernameController.text,
      password: passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExpeditionDashboard()),
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
        backgroundColor: polarDark,
        foregroundColor: Colors.white,
        title: const Text('Expedition Team Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Icon(Icons.explore, size: 80, color: polarDark),
                const SizedBox(height: 20),
                const Text(
                  'EXPEDITION TEAM',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: polarDeep,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Antarctic Expedition Personnel',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: polarBlue, fontSize: 14),
                ),
                const SizedBox(height: 40),
                LoginField(
                  controller: usernameController,
                  label: 'Personnel ID',
                  icon: Icons.badge,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Personnel ID is required.';
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
                  'Authorized expedition personnel only',
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
