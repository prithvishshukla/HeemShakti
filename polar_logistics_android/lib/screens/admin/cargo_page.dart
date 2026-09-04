import 'dart:math' as math;
import 'package:flutter/material.dart';

// ============================================================
// POLAR THEME COLORS
// ============================================================

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// CARGO ANALYTICS COLORS
// ============================================================

const Color cargoLightBlue = Color(0xFF38BDF8);
const Color cargoViolet = Color(0xFF8B5CF6);

class CargoPage extends StatelessWidget {
  const CargoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,
      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Cargo & Inventory'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cargo & Inventory',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Track cargo, supplies and inventory',
              style: TextStyle(color: polarBlue),
            ),
            const SizedBox(height: 25),

            // ============================================================
            // STAT CARDS
            // ============================================================

            Row(
              children: [
                Expanded(
                  child: CargoStatCard(
                    title: 'Total Items',
                    value: '248',
                    icon: Icons.inventory_2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CargoStatCard(
                    title: 'Pending',
                    value: '32',
                    icon: Icons.pending_actions,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CargoStatCard(
                    title: 'In Transit',
                    value: '84',
                    icon: Icons.local_shipping,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CargoStatCard(
                    title: 'Delivered',
                    value: '132',
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Cargo Inventory',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tap any cargo item to view inventory availability.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 15),

            // ============================================================
            // CARGO ITEMS
            // ============================================================

            CargoCard(
              id: 'CG-001',
              name: 'Food Supplies',
              category: 'Food & Provisions',
              quantity: '500 Units',
              destination: 'Maitri Station',
              status: 'Delivered',
              available: 350,
              notAvailable: 150,
            ),

            CargoCard(
              id: 'CG-002',
              name: 'Scientific Equipment',
              category: 'Research Equipment',
              quantity: '35 Units',
              destination: 'Bharati Station',
              status: 'In Transit',
              available: 25,
              notAvailable: 10,
            ),

            CargoCard(
              id: 'CG-003',
              name: 'Medical Supplies',
              category: 'Medical',
              quantity: '120 Units',
              destination: 'Maitri Station',
              status: 'Delivered',
              available: 100,
              notAvailable: 20,
            ),

            CargoCard(
              id: 'CG-004',
              name: 'Fuel Containers',
              category: 'Fuel & Energy',
              quantity: '80 Units',
              destination: 'Maitri Station',
              status: 'In Transit',
              available: 55,
              notAvailable: 25,
            ),

            CargoCard(
              id: 'CG-005',
              name: 'Winter Clothing',
              category: 'Personnel Supplies',
              quantity: '150 Units',
              destination: 'Bharati Station',
              status: 'Pending',
              available: 90,
              notAvailable: 60,
            ),

            CargoCard(
              id: 'CG-006',
              name: 'Communication Equipment',
              category: 'Communication',
              quantity: '25 Units',
              destination: 'Maitri Station',
              status: 'In Transit',
              available: 20,
              notAvailable: 5,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: polarDark,
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Cargo will be added next.'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================
// CARGO STAT CARD
// ============================================================

class CargoStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const CargoStatCard({
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
          Icon(
            icon,
            color: polarBlue,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: polarDeep,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARGO CARD
// ============================================================

class CargoCard extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final String quantity;
  final String destination;
  final String status;

  final int available;
  final int notAvailable;

  const CargoCard({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.destination,
    required this.status,
    required this.available,
    required this.notAvailable,
  });

  @override
  Widget build(BuildContext context) {
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

        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: polarVeryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.inventory_2,
            color: polarDark,
            size: 27,
          ),
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '$id\n$category\n$quantity • $destination',
          ),
        ),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: status == 'Delivered'
                    ? Colors.blueGrey
                    : status == 'In Transit'
                    ? Colors.lightBlue
                    : polarBlue,
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
              builder: (_) => CargoDetailsPage(
                id: id,
                name: name,
                category: category,
                quantity: quantity,
                destination: destination,
                status: status,
                available: available,
                notAvailable: notAvailable,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// CARGO DETAILS PAGE
// ============================================================

class CargoDetailsPage extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final String quantity;
  final String destination;
  final String status;

  final int available;
  final int notAvailable;

  const CargoDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.destination,
    required this.status,
    required this.available,
    required this.notAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final double total =
    (available + notAvailable).toDouble();

    final double availablePercentage =
    total == 0 ? 0 : (available / total) * 100;

    final double notAvailablePercentage =
    total == 0 ? 0 : (notAvailable / total) * 100;

    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Cargo Details'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // CARGO HEADER
            // ==========================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: polarLight),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 65,
                    color: polarDark,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: polarDeep,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    id,
                    style: const TextStyle(
                      color: polarBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  CargoStatusBadge(
                    status: status,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================================
            // INVENTORY AVAILABILITY
            // ==========================================================

            const Text(
              'Inventory Availability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Current availability of this cargo item',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: polarLight),
              ),
              child: Column(
                children: [
                  // ======================================================
                  // PIE / DONUT CHART
                  // ======================================================

                  SizedBox(
                    width: 210,
                    height: 210,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(210, 210),
                          painter: InventoryPieChartPainter(
                            available: available,
                            notAvailable: notAvailable,
                          ),
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${availablePercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: polarDeep,
                              ),
                            ),
                            const Text(
                              'Available',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ======================================================
                  // AVAILABLE - LIGHT BLUE
                  // ======================================================

                  InventoryLegendRow(
                    color: cargoLightBlue,
                    title: 'Available',
                    value: '$available Units',
                    percentage:
                    '${availablePercentage.toStringAsFixed(1)}%',
                  ),

                  const SizedBox(height: 12),

                  // ======================================================
                  // NOT AVAILABLE - VIOLET
                  // ======================================================

                  InventoryLegendRow(
                    color: cargoViolet,
                    title: 'Not Available',
                    value: '$notAvailable Units',
                    percentage:
                    '${notAvailablePercentage.toStringAsFixed(1)}%',
                  ),

                  const SizedBox(height: 18),

                  const Divider(),

                  const SizedBox(height: 12),

                  // ======================================================
                  // TOTAL
                  // ======================================================

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Inventory',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: polarDeep,
                        ),
                      ),
                      Text(
                        '${total.toInt()} Units',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: polarBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================================
            // CARGO INFORMATION
            // ==========================================================

            const Text(
              'Cargo Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            CargoDetailTile(
              icon: Icons.qr_code,
              title: 'Cargo ID',
              value: id,
            ),

            CargoDetailTile(
              icon: Icons.category,
              title: 'Category',
              value: category,
            ),

            CargoDetailTile(
              icon: Icons.numbers,
              title: 'Quantity',
              value: quantity,
            ),

            CargoDetailTile(
              icon: Icons.location_on,
              title: 'Destination',
              value: destination,
            ),

            CargoDetailTile(
              icon: Icons.local_shipping,
              title: 'Transport Status',
              value: status,
            ),

            const CargoDetailTile(
              icon: Icons.explore,
              title: 'Assigned Expedition',
              value: 'Antarctic Expedition 2026',
            ),

            const CargoDetailTile(
              icon: Icons.calendar_month,
              title: 'Dispatch Date',
              value: '10 January 2026',
            ),

            const SizedBox(height: 25),

            // ==========================================================
            // ACTIONS
            // ==========================================================

            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            const CargoActionButton(
              icon: Icons.location_on,
              title: 'Track Cargo',
            ),

            const CargoActionButton(
              icon: Icons.edit,
              title: 'Update Cargo Status',
            ),

            const CargoActionButton(
              icon: Icons.assignment,
              title: 'View Cargo History',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PIE / DONUT CHART PAINTER
// ============================================================

class InventoryPieChartPainter extends CustomPainter {
  final int available;
  final int notAvailable;

  InventoryPieChartPainter({
    required this.available,
    required this.notAvailable,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total =
    (available + notAvailable).toDouble();

    if (total <= 0) {
      return;
    }

    final Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final double radius =
        math.min(size.width, size.height) / 2;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35
      ..strokeCap = StrokeCap.butt;

    // ==========================================================
    // AVAILABLE - LIGHT BLUE
    // ==========================================================

    final double availableSweep =
        (available / total) * 2 * math.pi;

    paint.color = cargoLightBlue;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - 20,
      ),
      -math.pi / 2,
      availableSweep,
      false,
      paint,
    );

    // ==========================================================
    // NOT AVAILABLE - VIOLET
    // ==========================================================

    paint.color = cargoViolet;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - 20,
      ),
      -math.pi / 2 + availableSweep,
      (notAvailable / total) * 2 * math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant InventoryPieChartPainter oldDelegate,
      ) {
    return oldDelegate.available != available ||
        oldDelegate.notAvailable != notAvailable;
  }
}

// ============================================================
// INVENTORY LEGEND ROW
// ============================================================

class InventoryLegendRow extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final String percentage;

  const InventoryLegendRow({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: polarDeep,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 52,
          child: Text(
            percentage,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// STATUS BADGE
// ============================================================

class CargoStatusBadge extends StatelessWidget {
  final String status;

  const CargoStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    if (status == 'Delivered') {
      statusColor = Colors.green;
    } else if (status == 'In Transit') {
      statusColor = Colors.orange;
    } else {
      statusColor = polarBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// CARGO DETAIL TILE
// ============================================================

class CargoDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const CargoDetailTile({
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
        border: Border.all(color: polarLight),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

// ============================================================
// CARGO ACTION BUTTON
// ============================================================

class CargoActionButton extends StatelessWidget {
  final IconData icon;
  final String title;

  const CargoActionButton({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title open wide'),
            ),
          );
        },
        icon: Icon(
          icon,
          color: polarBlue,
        ),
        label: Text(
          title,
          style: const TextStyle(
            color: polarDeep,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          side: const BorderSide(
            color: polarLight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}