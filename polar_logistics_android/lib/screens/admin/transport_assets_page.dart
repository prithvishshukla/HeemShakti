import 'package:flutter/material.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

class TransportAssetsPage extends StatelessWidget {
  const TransportAssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Transport & Assets'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transport & Assets',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage expedition vehicles and operational assets',
              style: TextStyle(
                color: polarBlue,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: AssetStatCard(
                    title: 'Total Assets',
                    value: '36',
                    icon: Icons.inventory,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AssetStatCard(
                    title: 'Available',
                    value: '18',
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: AssetStatCard(
                    title: 'In Use',
                    value: '12',
                    icon: Icons.directions_car,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AssetStatCard(
                    title: 'Maintenance',
                    value: '06',
                    icon: Icons.build,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Asset Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            AssetCategoryCard(
              title: 'Vehicles',
              subtitle:
              'Manage expedition vehicles and transport',
              icon: Icons.directions_car,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const VehicleListPage(),
                  ),
                );
              },
            ),

            AssetCategoryCard(
              title: 'Equipment',
              subtitle:
              'Manage field and operational equipment',
              icon: Icons.precision_manufacturing,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const EquipmentListPage(),
                  ),
                );
              },
            ),

            AssetCategoryCard(
              title: 'Asset Status',
              subtitle:
              'Monitor availability and maintenance',
              icon: Icons.assessment,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AssetStatusPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Recent Assets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            AssetListCard(
              assetId: 'AST-001',
              name: 'Polar Transport Vehicle 01',
              type: 'Snow Vehicle',
              location: 'Maitri Station',
              assignedTo: 'Expedition Team',
              status: 'In Use',
            ),

            AssetListCard(
              assetId: 'AST-002',
              name: 'Field Generator 02',
              type: 'Generator',
              location: 'Bharati Station',
              assignedTo: 'Operations',
              status: 'Available',
            ),

            AssetListCard(
              assetId: 'AST-003',
              name: 'ATV-03',
              type: 'ATV',
              location: 'Field Camp',
              assignedTo: 'Expedition Team',
              status: 'Maintenance',
            ),

            AssetListCard(
              assetId: 'AST-004',
              name: 'Satellite Communication Unit',
              type: 'Communication',
              location: 'Maitri Station',
              assignedTo: 'Communications',
              status: 'Available',
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
              content: Text(
                'Add Asset feature will be implemented next.',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================
// STAT CARD
// ============================================================

class AssetStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const AssetStatCard({
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
              fontSize: 25,
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
// CATEGORY CARD
// ============================================================

class AssetCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const AssetCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: polarLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: polarVeryLight,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: polarDark,
          ),
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
          size: 16,
          color: polarBlue,
        ),

        onTap: onTap,
      ),
    );
  }
}

// ============================================================
// VEHICLE LIST
// ============================================================

class VehicleListPage extends StatelessWidget {
  const VehicleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Vehicles'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          VehicleCard(
            id: 'VEH-001',
            name: 'Polar Transport Vehicle 01',
            type: 'Snow Vehicle',
            location: 'Maitri Station',
            status: 'In Use',
          ),

          VehicleCard(
            id: 'VEH-002',
            name: 'Polar Transport Vehicle 02',
            type: 'Snow Vehicle',
            location: 'Bharati Station',
            status: 'Available',
          ),

          VehicleCard(
            id: 'VEH-003',
            name: 'ATV-03',
            type: 'ATV',
            location: 'Field Camp',
            status: 'Maintenance',
          ),

          VehicleCard(
            id: 'VEH-004',
            name: 'Cargo Transport Truck',
            type: 'Truck',
            location: 'Maitri Station',
            status: 'Available',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VEHICLE CARD
// ============================================================

class VehicleCard extends StatelessWidget {
  final String id;
  final String name;
  final String type;
  final String location;
  final String status;

  const VehicleCard({
    super.key,
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: polarLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: const Icon(
          Icons.directions_car,
          size: 38,
          color: polarDark,
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),

        subtitle: Text(
          '$id\n$type • $location',
        ),

        trailing: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: status == 'Available'
                ? Colors.green
                : status == 'In Use'
                ? polarBlue
                : Colors.orange,
          ),
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailsPage(
                id: id,
                name: name,
                type: type,
                location: location,
                status: status,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// VEHICLE DETAILS
// ============================================================

class VehicleDetailsPage extends StatelessWidget {
  final String id;
  final String name;
  final String type;
  final String location;
  final String status;

  const VehicleDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Vehicle Details'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                    Icons.directions_car,
                    size: 70,
                    color: polarDark,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
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
                ],
              ),
            ),

            const SizedBox(height: 20),

            AssetDetailTile(
              icon: Icons.category,
              title: 'Type',
              value: type,
            ),

            AssetDetailTile(
              icon: Icons.location_on,
              title: 'Location',
              value: location,
            ),

            AssetDetailTile(
              icon: Icons.info,
              title: 'Status',
              value: status,
            ),

            const AssetDetailTile(
              icon: Icons.person,
              title: 'Assigned To',
              value: 'Expedition Team',
            ),

            const AssetDetailTile(
              icon: Icons.build,
              title: 'Last Maintenance',
              value: '15 August 2026',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EQUIPMENT LIST
// ============================================================

class EquipmentListPage extends StatelessWidget {
  const EquipmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Equipment'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          EquipmentCard(
            id: 'EQP-001',
            name: 'Field Generator 02',
            type: 'Generator',
            location: 'Bharati Station',
            status: 'Available',
          ),

          EquipmentCard(
            id: 'EQP-002',
            name: 'Satellite Communication Unit',
            type: 'Communication',
            location: 'Maitri Station',
            status: 'In Use',
          ),

          EquipmentCard(
            id: 'EQP-003',
            name: 'Field Safety Kit',
            type: 'Safety Equipment',
            location: 'Field Camp',
            status: 'Available',
          ),

          EquipmentCard(
            id: 'EQP-004',
            name: 'Portable Generator',
            type: 'Generator',
            location: 'Maitri Station',
            status: 'Maintenance',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EQUIPMENT CARD
// ============================================================

class EquipmentCard extends StatelessWidget {
  final String id;
  final String name;
  final String type;
  final String location;
  final String status;

  const EquipmentCard({
    super.key,
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: polarLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: const Icon(
          Icons.precision_manufacturing,
          size: 38,
          color: polarDark,
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),

        subtitle: Text(
          '$id\n$type • $location',
        ),

        trailing: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: status == 'Available'
                ? Colors.green
                : status == 'In Use'
                ? polarBlue
                : Colors.orange,
          ),
        ),

        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$name selected.',
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// ASSET STATUS
// ============================================================

class AssetStatusPage extends StatelessWidget {
  const AssetStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Asset Status'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StatusCard(
            title: 'Available',
            count: '18 Assets',
            icon: Icons.check_circle,
            statusColor: Colors.green,
          ),

          StatusCard(
            title: 'In Use',
            count: '12 Assets',
            icon: Icons.directions_car,
            statusColor: polarBlue,
          ),

          StatusCard(
            title: 'Maintenance',
            count: '06 Assets',
            icon: Icons.build,
            statusColor: Colors.orange,
          ),

          StatusCard(
            title: 'Out of Service',
            count: '00 Assets',
            icon: Icons.cancel,
            statusColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS CARD
// ============================================================

class StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color statusColor;

  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: polarLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),

        leading: Icon(
          icon,
          size: 40,
          color: statusColor,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),

        subtitle: Text(count),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: polarBlue,
        ),
      ),
    );
  }
}

// ============================================================
// ASSET LIST CARD
// ============================================================

class AssetListCard extends StatelessWidget {
  final String assetId;
  final String name;
  final String type;
  final String location;
  final String assignedTo;
  final String status;

  const AssetListCard({
    super.key,
    required this.assetId,
    required this.name,
    required this.type,
    required this.location,
    required this.assignedTo,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: polarLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: const Icon(
          Icons.inventory,
          color: polarDark,
          size: 35,
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: polarDeep,
          ),
        ),

        subtitle: Text(
          '$assetId\n$type • $location\nAssigned: $assignedTo',
        ),

        trailing: Text(
          status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: status == 'Available'
                ? Colors.green
                : status == 'In Use'
                ? polarBlue
                : Colors.orange,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL TILE
// ============================================================

class AssetDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const AssetDetailTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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