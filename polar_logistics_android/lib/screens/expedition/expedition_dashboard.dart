import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/auth_gate.dart';
import '../../widgets/dashboard_widgets.dart';
import '../start_menu.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// EXPEDITION DASHBOARD
// ------------------------------------------------------------
// Only reachable by an authenticated, active Expedition session.
// AuthGate re-validates the session (and account status) every time
// this screen is built - if an Admin deactivates this account, the
// very next time this screen is opened the user is redirected back
// to StartMenu instead of seeing this content.
// ============================================================
class ExpeditionDashboard extends StatelessWidget {
  const ExpeditionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      requiredRole: UserRole.expedition,
      builder: (context, user) => _ExpeditionDashboardContent(user: user),
    );
  }
}

class _ExpeditionDashboardContent extends StatelessWidget {
  final AppUser user;

  const _ExpeditionDashboardContent({required this.user});

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StartMenu()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = user.personnelRole?.label ?? 'Expedition Member';

    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarDark,
        foregroundColor: Colors.white,
        title: const Text('Expedition Dashboard'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.fullName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$roleLabel • Personnel ID: ${user.username}',
              style: const TextStyle(color: polarBlue),
            ),
            const SizedBox(height: 25),

            // CURRENT EXPEDITION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: polarLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURRENT EXPEDITION',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: polarBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.expeditionId != null && user.expeditionId!.isNotEmpty
                        ? user.expeditionId!
                        : 'Antarctic Expedition 2026',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: polarDeep,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Status: Active',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              'My Operations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),
            const SizedBox(height: 15),

            DashboardMenuCard(
              title: 'My Expedition',
              subtitle: 'View current expedition details',
              icon: Icons.explore,
              onTap: () => showModuleMessage(context, 'My Expedition'),
            ),

            DashboardMenuCard(
              title: 'Cargo',
              subtitle: 'View assigned cargo and supplies',
              icon: Icons.inventory_2,
              onTap: () => showModuleMessage(context, 'Cargo'),
            ),

            DashboardMenuCard(
              title: 'Tasks',
              subtitle: 'View assigned operational tasks',
              icon: Icons.task_alt,
              onTap: () => showModuleMessage(context, 'Tasks'),
            ),

            DashboardMenuCard(
              title: 'Personnel',
              subtitle: 'View expedition team members',
              icon: Icons.people,
              onTap: () => showModuleMessage(context, 'Personnel'),
            ),

            DashboardMenuCard(
              title: 'Reports & Updates',
              subtitle: 'Submit expedition updates and reports',
              icon: Icons.assignment,
              onTap: () => showModuleMessage(context, 'Reports & Updates'),
            ),

            DashboardMenuCard(
              title: 'Emergency',
              subtitle: 'Emergency information and contacts',
              icon: Icons.warning_amber,
              onTap: () => showModuleMessage(context, 'Emergency'),
            ),
          ],
        ),
      ),
    );
  }
}
