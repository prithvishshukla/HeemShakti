import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'repositories/user_repository.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/expedition/expedition_dashboard.dart';
import 'screens/start_menu.dart';
import 'services/auth_service.dart';

// ============================================================
// COLOUR PALETTE
// ============================================================

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// APP ENTRY POINT
// ------------------------------------------------------------
// UserRepository.init() opens the local Hive user store and, on the
// very first run, seeds the initial NCPOR Admin account (see the
// "ADMIN BOOTSTRAP" comment block in repositories/user_repository.dart
// for full details and the default credentials).
// ============================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserRepository.instance.init();
  runApp(const PolarLogisticsApp());
}

// ============================================================
// APP
// ============================================================

class PolarLogisticsApp extends StatelessWidget {
  const PolarLogisticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Polar Logistics',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: polarVeryLight,
        colorScheme: ColorScheme.fromSeed(seedColor: polarBlue),
      ),
      home: const SessionGate(),
    );
  }
}

// ============================================================
// SESSION GATE
// ------------------------------------------------------------
// Runs once at startup. If a valid, still-active session exists,
// the user is sent straight to their role-appropriate dashboard
// (Admin or Expedition). Otherwise the existing StartMenu (with its
// two login options) is shown. This is what makes login "persist
// until logout" across app restarts.
// ============================================================
class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late final Future<AppUser?> _restoredUser;

  @override
  void initState() {
    super.initState();
    _restoredUser = AuthService.instance.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: _restoredUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: polarVeryLight,
            body: Center(
              child: CircularProgressIndicator(color: polarBlue),
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const StartMenu();
        }
        if (user.role == UserRole.admin) {
          return const AdminDashboard();
        }
        return const ExpeditionDashboard();
      },
    );
  }
}
