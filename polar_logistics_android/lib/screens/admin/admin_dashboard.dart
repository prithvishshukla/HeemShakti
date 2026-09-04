import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/auth_gate.dart';
import '../../widgets/dashboard_widgets.dart';
import '../start_menu.dart';
import 'cargo_page.dart';
import 'expeditions_page.dart';
import 'manage_expedition_users_page.dart';
import 'personnel_page.dart';
import 'reports_page.dart';
import 'transport_assets_page.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// ADMIN DASHBOARD
// ------------------------------------------------------------
// Only reachable by an authenticated Admin session. AuthGate
// re-validates the session (and account status) every time this
// screen is built, so navigating here without a valid Admin session
// always redirects to StartMenu instead of showing this content.
// ============================================================
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      requiredRole: UserRole.admin,
      builder: (context, admin) => _AdminDashboardContent(admin: admin),
    );
  }
}

class _AdminDashboardContent extends StatelessWidget {
  final AppUser admin;

  const _AdminDashboardContent({required this.admin});

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
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('NCPOR Dashboard'),
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
              'Welcome, ${admin.fullName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Antarctic Logistics Control Centre',
              style: TextStyle(color: polarBlue),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Expanded(
                  child: DashboardStat(
                    title: 'Expeditions',
                    value: '12',
                    icon: Icons.explore,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: DashboardStat(
                    title: 'Personnel',
                    value: '6',
                    icon: Icons.people,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: DashboardStat(
                    title: 'Cargo',
                    value: '248',
                    icon: Icons.inventory_2,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: DashboardStat(
                    title: 'Assets',
                    value: '36',
                    icon: Icons.local_shipping,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),
            const SizedBox(height: 15),

            DashboardMenuCard(
              title: 'Expeditions',
              subtitle: 'Create and manage Antarctic expeditions',
              icon: Icons.explore,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpeditionsPage()),
                );
              },
            ),

            DashboardMenuCard(
              title: 'Personnel',
              subtitle: 'Manage expedition personnel and roles',
              icon: Icons.people,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PersonnelPage()),
                );
              },
            ),

            // ==================================================
            // NEW: Admin-controlled Expedition user accounts.
            // ==================================================
            DashboardMenuCard(
              title: 'Manage Expedition Users',
              subtitle:
                  'Create, edit, and activate/deactivate login accounts',
              icon: Icons.manage_accounts,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageExpeditionUsersPage(),
                  ),
                );
              },
            ),

            DashboardMenuCard(
              title: 'Cargo & Inventory',
              subtitle: 'Track cargo, supplies and inventory',
              icon: Icons.inventory_2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CargoPage()),
                );
              },
            ),

            DashboardMenuCard(
              title: 'Transport & Assets',
              subtitle: 'Manage vehicles and expedition assets',
              icon: Icons.local_shipping,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TransportAssetsPage(),
                  ),
                );
              },
            ),

            DashboardMenuCard(
              title: 'Reports',
              subtitle: 'View operational and logistics reports',
              icon: Icons.bar_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
