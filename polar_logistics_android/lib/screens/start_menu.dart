import 'package:flutter/material.dart';

import 'auth/admin_login_page.dart';
import 'auth/expedition_login_page.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// START MENU
// ------------------------------------------------------------
// The app's single entry point. Exposes exactly two authentication
// paths - NCPOR / Admin Login and Expedition Team Login - and
// nothing else. There is intentionally no register/sign-up, guest,
// social, or OTP login anywhere in this screen or the app.
// ============================================================
class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.ac_unit, size: 90, color: polarDark),
                const SizedBox(height: 24),
                const Text(
                  'POLAR LOGISTICS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: polarDeep,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Antarctic Expedition Management',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: polarBlue),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text(
                      'LOGIN — NCPOR / ADMIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: polarBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpeditionLoginPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.explore),
                    label: const Text(
                      'LOGIN — EXPEDITION TEAM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: polarDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'NCPOR • Antarctic Operations',
                  style: TextStyle(fontSize: 12, color: polarBlue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
