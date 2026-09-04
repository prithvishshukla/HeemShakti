import 'package:flutter/material.dart';

// Local, self-contained colour palette copy (matches project convention).
const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// DASHBOARD STAT
// ------------------------------------------------------------
// Shared between the Admin and Expedition dashboards (moved here
// from main.dart so it is defined exactly once).
// ============================================================
class DashboardStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardStat({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: polarLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: polarBlue, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: polarDeep,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD MENU CARD
// ============================================================
class DashboardMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: polarLight),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: polarVeryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: polarDark),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: polarDeep,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 17,
            color: polarBlue,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

// ============================================================
// TEMPORARY MODULE MESSAGE
// ------------------------------------------------------------
// Preserved as-is for the still-unimplemented Expedition dashboard
// modules (Cargo, Tasks, Reports & Updates, Emergency, ...).
// ============================================================
void showModuleMessage(BuildContext context, String module) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$module module will open here.')),
  );
}
