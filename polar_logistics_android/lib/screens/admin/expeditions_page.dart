import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

// ============================================================
// EXPEDITION DATA MODEL
// ============================================================

class ExpeditionData {
  final String id;
  final String name;
  final String destination;
  final String status;
  final double lat;
  final double lng;

  const ExpeditionData({
    required this.id,
    required this.name,
    required this.destination,
    required this.status,
    required this.lat,
    required this.lng,
  });
}

// ============================================================
// EXPEDITION DATA
// ============================================================

const List<ExpeditionData> expeditions = [
  ExpeditionData(
    id: 'EXP-2026-001',
    name: 'Antarctic Expedition 2026',
    destination: 'Maitri Station',
    status: 'Active',
    lat: 28.4744,
    lng: 77.5040,
  ),
  ExpeditionData(
    id: 'EXP-2026-002',
    name: 'Scientific Research Expedition',
    destination: 'Bharati Station',
    status: 'Planned',
    lat: 28.4744,
    lng: 77.5040,
  ),
  ExpeditionData(
    id: 'EXP-2026-003',
    name: 'Winter Research Expedition',
    destination: 'Antarctica',
    status: 'Planned',
    lat: 28.4744,
    lng: 77.5040,
  ),
];

// ============================================================
// EXPEDITIONS PAGE
// ============================================================

class ExpeditionsPage extends StatelessWidget {
  const ExpeditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'Expedition Management',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expeditions',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage and monitor Antarctic expeditions',
              style: TextStyle(
                color: polarBlue,
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // STATISTICS
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total',
                    value: '12',
                    icon: Icons.explore,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Active',
                    value: '5',
                    icon: Icons.flight_takeoff,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Planned',
                    value: '4',
                    icon: Icons.event,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Completed',
                    value: '3',
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // ANTARCTICA MAP TITLE
            // ==================================================

            const Text(
              'Antarctica Expedition Map',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Live expedition locations and research stations',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ANTARCTICA OVERVIEW MAP
            // ==================================================

            const ExpeditionsOverviewMap(),

            const SizedBox(height: 30),

            // ==================================================
            // EXPEDITION LIST
            // ==================================================

            const Text(
              'Expedition List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            ExpeditionCard(
              id: 'EXP-2026-001',
              name: 'Antarctic Expedition 2026',
              destination: 'Maitri Station',
              status: 'Active',
              lat: 28.4744,
              lng: 77.5040,
            ),

            ExpeditionCard(
              id: 'EXP-2026-002',
              name: 'Scientific Research Expedition',
              destination: 'Bharati Station',
              status: 'Planned',
              lat: 28.4744,
              lng: 77.5040,
            ),

            ExpeditionCard(
              id: 'EXP-2026-003',
              name: 'Winter Research Expedition',
              destination: 'Antarctica',
              status: 'Planned',
              lat: 28.4744,
              lng: 77.5040,
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
                'Create Expedition will be added next.',
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
// ANTARCTICA OVERVIEW MAP
// ============================================================

class ExpeditionsOverviewMap extends StatelessWidget {
  const ExpeditionsOverviewMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: polarLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              // Center of Greater Noida
              initialCenter: LatLng(28.4744, 77.5040),

              // Zoom into Greater Noida
              initialZoom: 12.0,

              minZoom: 1.5,
              maxZoom: 10.0,
            ),

            children: [
              // ==================================================
              // OPENSTREETMAP
              // ==================================================

              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'in.ncpor.polarlogistics',
              ),

              // ==================================================
              // EXPEDITION MARKERS
              // ==================================================

              MarkerLayer(
                markers: expeditions.map(
                      (expedition) {
                    return Marker(
                      point: LatLng(
                        expedition.lat,
                        expedition.lng,
                      ),
                      width: 100,
                      height: 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            child: Text(
                              expedition.destination,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: polarDeep,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.location_on,
                            color: polarDark,
                            size: 36,
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),

              // ==================================================
              // OPENSTREETMAP ATTRIBUTION
              // ==================================================

              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          // ==================================================
          // MAP TITLE BADGE
          // ==================================================

          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.ac_unit,
                    color: polarBlue,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ANTARCTICA',
                    style: TextStyle(
                      fontSize: 12,
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

// ============================================================
// STAT CARD
// ============================================================

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
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
// EXPEDITION CARD
// ============================================================

class ExpeditionCard extends StatelessWidget {
  final String id;
  final String name;
  final String destination;
  final String status;
  final double lat;
  final double lng;

  const ExpeditionCard({
    super.key,
    required this.id,
    required this.name,
    required this.destination,
    required this.status,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: polarVeryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.explore,
            color: polarDark,
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
            '$id\n$destination',
          ),
        ),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == 'Active'
                    ? Colors.green
                    : polarBlue,
              ),
            ),

            const SizedBox(height: 5),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: polarBlue,
            ),
          ],
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpeditionDetailsPage(
                id: id,
                name: name,
                destination: destination,
                status: status,
                lat: lat,
                lng: lng,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// EXPEDITION DETAILS PAGE
// ============================================================

class ExpeditionDetailsPage extends StatelessWidget {
  final String id;
  final String name;
  final String destination;
  final String status;
  final double lat;
  final double lng;

  const ExpeditionDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.destination,
    required this.status,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'Expedition Details',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // EXPEDITION HEADER
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: polarLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.explore,
                    size: 55,
                    color: polarDark,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
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

                  StatusBadge(
                    status: status,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // EXPEDITION INFORMATION
            // ==================================================

            const Text(
              'Expedition Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            DetailTile(
              icon: Icons.location_on,
              title: 'Destination',
              value: destination,
            ),

            const DetailTile(
              icon: Icons.calendar_month,
              title: 'Start Date',
              value: '15 January 2026',
            ),

            const DetailTile(
              icon: Icons.event_available,
              title: 'End Date',
              value: '30 March 2026',
            ),

            const DetailTile(
              icon: Icons.people,
              title: 'Team Members',
              value: '24 Personnel',
            ),

            const DetailTile(
              icon: Icons.inventory_2,
              title: 'Assigned Cargo',
              value: '84 Items',
            ),

            const DetailTile(
              icon: Icons.precision_manufacturing,
              title: 'Assigned Assets',
              value: '16 Assets',
            ),

            const SizedBox(height: 25),

            // ==================================================
            // LOCATION
            // ==================================================

            const Text(
              'Expedition Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              destination,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // INDIVIDUAL MAP
            // ==================================================

            ExpeditionLocationMap(
              lat: lat,
              lng: lng,
              destination: destination,
            ),

            const SizedBox(height: 25),

            // ==================================================
            // OPERATIONS
            // ==================================================

            const Text(
              'Operations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            ActionButton(
              icon: Icons.inventory_2,
              title: 'View Assigned Cargo',
            ),

            ActionButton(
              icon: Icons.people,
              title: 'View Team Members',
            ),

            ActionButton(
              icon: Icons.precision_manufacturing,
              title: 'View Assigned Assets',
            ),

            ActionButton(
              icon: Icons.location_on,
              title: 'Track Expedition',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INDIVIDUAL EXPEDITION LOCATION MAP
// ============================================================

class ExpeditionLocationMap extends StatelessWidget {
  final double lat;
  final double lng;
  final String destination;

  const ExpeditionLocationMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: polarLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                lat,
                lng,
              ),
              initialZoom: 5.0,
              minZoom: 2.0,
              maxZoom: 15.0,
            ),

            children: [
              // ==================================================
              // OPENSTREETMAP TILES
              // ==================================================

              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'in.ncpor.polarlogistics',
              ),

              // ==================================================
              // LOCATION MARKER
              // ==================================================

              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      lat,
                      lng,
                    ),
                    width: 130,
                    height: 75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(7),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          child: Text(
                            destination,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: polarDeep,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.location_on,
                          color: polarDark,
                          size: 42,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ==================================================
              // ATTRIBUTION
              // ==================================================

              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          // ==================================================
          // LOCATION BADGE
          // ==================================================

          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: polarDark,
                    size: 17,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'EXPEDITION LOCATION',
                    style: TextStyle(
                      fontSize: 10,
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

// ============================================================
// STATUS BADGE
// ============================================================

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: active
            ? Colors.green.withValues(alpha: 0.12)
            : polarVeryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active
              ? Colors.green
              : polarBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL TILE
// ============================================================

class DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
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

// ============================================================
// ACTION BUTTON
// ============================================================

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;

  const ActionButton({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$title will open here.',
              ),
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
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          side: const BorderSide(
            color: polarLight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}