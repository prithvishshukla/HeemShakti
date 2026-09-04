import 'package:flutter/material.dart';

import '../../models/report_model.dart';
import '../../services/api_service.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late Future<ReportSummary> _reportFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    _reportFuture = ApiService.getReportSummary();
  }

  Future<void> _refreshReports() async {
    setState(() {
      _loadReports();
    });

    await _reportFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadReports();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<ReportSummary>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: polarBlue,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildErrorState('No report data available.');
          }

          return _buildReportContent(snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: polarDark,
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Live report data is automatically generated from the backend.',
              ),
            ),
          );
        },
        child: const Icon(Icons.analytics),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: polarLight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 60,
                color: polarDark,
              ),
              const SizedBox(height: 16),
              const Text(
                'Unable to Load Reports',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: polarDeep,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _loadReports();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: polarBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent(ReportSummary report) {
    final int totalReports =
        report.personnel.total + report.cargo.total;

    final int pendingReports =
        report.cargo.pending;

    final int completedReports =
        report.cargo.delivered + report.personnel.active;

    final int alerts =
        report.personnel.inactive +
            report.inventory.notAvailable;

    return RefreshIndicator(
      color: polarBlue,
      onRefresh: _refreshReports,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports & Analytics',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Live data from Antarctic operations',
              style: TextStyle(
                color: polarBlue,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: ReportStatCard(
                    title: 'Records',
                    value: totalReports.toString(),
                    icon: Icons.description,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ReportStatCard(
                    title: 'Pending',
                    value: pendingReports.toString(),
                    icon: Icons.pending_actions,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ReportStatCard(
                    title: 'Completed',
                    value: completedReports.toString(),
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ReportStatCard(
                    title: 'Alerts',
                    value: alerts.toString(),
                    icon: Icons.warning_amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Live Operations Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            _buildSummaryCard(
              icon: Icons.people,
              title: 'Personnel Report',
              items: [
                _SummaryItem(
                  label: 'Total Personnel',
                  value: report.personnel.total.toString(),
                ),
                _SummaryItem(
                  label: 'Active',
                  value: report.personnel.active.toString(),
                ),
                _SummaryItem(
                  label: 'Inactive',
                  value: report.personnel.inactive.toString(),
                ),
                _SummaryItem(
                  label: 'Active Percentage',
                  value:
                  '${report.personnel.activePercentage.toStringAsFixed(1)}%',
                ),
              ],
            ),

            _buildSummaryCard(
              icon: Icons.inventory_2,
              title: 'Cargo Report',
              items: [
                _SummaryItem(
                  label: 'Total Cargo',
                  value: report.cargo.total.toString(),
                ),
                _SummaryItem(
                  label: 'Delivered',
                  value: report.cargo.delivered.toString(),
                ),
                _SummaryItem(
                  label: 'In Transit',
                  value: report.cargo.inTransit.toString(),
                ),
                _SummaryItem(
                  label: 'Pending',
                  value: report.cargo.pending.toString(),
                ),
              ],
            ),

            _buildSummaryCard(
              icon: Icons.warehouse,
              title: 'Inventory Report',
              items: [
                _SummaryItem(
                  label: 'Total Quantity',
                  value: report.inventory.total.toString(),
                ),
                _SummaryItem(
                  label: 'Available',
                  value: report.inventory.available.toString(),
                ),
                _SummaryItem(
                  label: 'Not Available',
                  value: report.inventory.notAvailable.toString(),
                ),
                _SummaryItem(
                  label: 'Availability',
                  value:
                  '${report.inventory.availablePercentage.toStringAsFixed(1)}%',
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Available Reports',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            ReportCard(
              id: 'RPT-001',
              title: 'Personnel Report',
              category: 'Personnel',
              date: 'Live Backend Data',
              status: 'Completed',
              icon: Icons.people,
              report: report,
              type: ReportType.personnel,
            ),

            ReportCard(
              id: 'RPT-002',
              title: 'Cargo & Inventory Report',
              category: 'Logistics',
              date: 'Live Backend Data',
              status: pendingReports > 0
                  ? 'Pending'
                  : 'Completed',
              icon: Icons.inventory_2,
              report: report,
              type: ReportType.cargo,
            ),

            ReportCard(
              id: 'RPT-003',
              title: 'Inventory Availability Report',
              category: 'Inventory',
              date: 'Live Backend Data',
              status: report.inventory.notAvailable > 0
                  ? 'Pending'
                  : 'Completed',
              icon: Icons.warehouse,
              report: report,
              type: ReportType.inventory,
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Pull down to refresh live backend data',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required List<_SummaryItem> items,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: polarLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: polarDark,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: polarDeep,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: polarDeep,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final String label;
  final String value;

  _SummaryItem({
    required this.label,
    required this.value,
  });
}

// ============================================================
// REPORT STAT CARD
// ============================================================

class ReportStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ReportStatCard({
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
        border: Border.all(
          color: polarLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: polarBlue,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: polarDeep,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REPORT TYPE
// ============================================================

enum ReportType {
  personnel,
  cargo,
  inventory,
}

// ============================================================
// REPORT CARD
// ============================================================

class ReportCard extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String date;
  final String status;
  final IconData icon;
  final ReportSummary report;
  final ReportType type;

  const ReportCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.status,
    required this.icon,
    required this.report,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: polarLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: polarVeryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: polarDark,
            size: 27,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '$id\n$category • $date',
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: status == 'Completed'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            const SizedBox(height: 6),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: polarBlue,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportDetailsPage(
                id: id,
                title: title,
                category: category,
                date: date,
                status: status,
                report: report,
                type: type,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// REPORT DETAILS
// ============================================================

class ReportDetailsPage extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String date;
  final String status;
  final ReportSummary report;
  final ReportType type;

  const ReportDetailsPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.status,
    required this.report,
    required this.type,
  });

  List<ReportDetailTile> _getLiveDetails() {
    switch (type) {
      case ReportType.personnel:
        return [
          ReportDetailTile(
            icon: Icons.people,
            title: 'Total Personnel',
            value: report.personnel.total.toString(),
          ),
          ReportDetailTile(
            icon: Icons.check_circle,
            title: 'Active Personnel',
            value: report.personnel.active.toString(),
          ),
          ReportDetailTile(
            icon: Icons.person_off,
            title: 'Inactive Personnel',
            value: report.personnel.inactive.toString(),
          ),
          ReportDetailTile(
            icon: Icons.percent,
            title: 'Active Percentage',
            value:
            '${report.personnel.activePercentage.toStringAsFixed(1)}%',
          ),
        ];

      case ReportType.cargo:
        return [
          ReportDetailTile(
            icon: Icons.inventory,
            title: 'Total Cargo',
            value: report.cargo.total.toString(),
          ),
          ReportDetailTile(
            icon: Icons.check_circle,
            title: 'Delivered',
            value: report.cargo.delivered.toString(),
          ),
          ReportDetailTile(
            icon: Icons.local_shipping,
            title: 'In Transit',
            value: report.cargo.inTransit.toString(),
          ),
          ReportDetailTile(
            icon: Icons.pending_actions,
            title: 'Pending',
            value: report.cargo.pending.toString(),
          ),
        ];

      case ReportType.inventory:
        return [
          ReportDetailTile(
            icon: Icons.inventory_2,
            title: 'Total Quantity',
            value: report.inventory.total.toString(),
          ),
          ReportDetailTile(
            icon: Icons.check_circle,
            title: 'Available',
            value: report.inventory.available.toString(),
          ),
          ReportDetailTile(
            icon: Icons.cancel,
            title: 'Not Available',
            value: report.inventory.notAvailable.toString(),
          ),
          ReportDetailTile(
            icon: Icons.percent,
            title: 'Availability',
            value:
            '${report.inventory.availablePercentage.toStringAsFixed(1)}%',
          ),
        ];
    }
  }

  String _getSummaryText() {
    switch (type) {
      case ReportType.personnel:
        return 'Live personnel information from the backend. '
            'The system currently contains ${report.personnel.total} personnel, '
            'with ${report.personnel.active} active personnel.';

      case ReportType.cargo:
        return 'Live cargo status information from the backend. '
            'Total cargo records: ${report.cargo.total}. '
            '${report.cargo.delivered} delivered, '
            '${report.cargo.inTransit} currently in transit, '
            'and ${report.cargo.pending} pending.';

      case ReportType.inventory:
        return 'Live inventory availability information from the backend. '
            'Total quantity: ${report.inventory.total}, '
            'with ${report.inventory.available} available and '
            '${report.inventory.notAvailable} unavailable.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = _getLiveDetails();

    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Report Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: polarLight,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.description,
                    size: 65,
                    color: polarDark,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: polarDeep,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    id,
                    style: const TextStyle(
                      color: polarBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ReportStatusBadge(
                    status: status,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Report Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            ReportDetailTile(
              icon: Icons.numbers,
              title: 'Report ID',
              value: id,
            ),

            ReportDetailTile(
              icon: Icons.category,
              title: 'Category',
              value: category,
            ),

            ReportDetailTile(
              icon: Icons.cloud,
              title: 'Data Source',
              value: 'Live FastAPI Backend',
            ),

            ...details,

            const SizedBox(height: 25),

            const Text(
              'Report Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: polarLight,
                ),
              ),
              child: Text(
                _getSummaryText(),
                style: const TextStyle(
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STATUS BADGE
// ============================================================

class ReportStatusBadge extends StatelessWidget {
  final String status;

  const ReportStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool completed = status == 'Completed';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: completed
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: completed
              ? Colors.green
              : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL TILE
// ============================================================

class ReportDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ReportDetailTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: polarLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: polarBlue,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: polarDeep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}