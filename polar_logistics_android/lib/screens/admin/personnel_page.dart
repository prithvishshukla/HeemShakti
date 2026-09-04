import 'package:flutter/material.dart';

const Color polarVeryLight = Color(0xFFE3F2FD);
const Color polarLight = Color(0xFF90CAF9);
const Color polarBlue = Color(0xFF2196F3);
const Color polarDark = Color(0xFF1565C0);
const Color polarDeep = Color(0xFF0D47A1);

class PersonnelPage extends StatelessWidget {
  const PersonnelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Personnel Management'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personnel',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage Antarctic expedition personnel',
              style: TextStyle(
                color: polarBlue,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: PersonnelStatCard(
                    title: 'Total',
                    value: '86',
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PersonnelStatCard(
                    title: 'Active',
                    value: '64',
                    icon: Icons.person,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: PersonnelStatCard(
                    title: 'On Expedition',
                    value: '24',
                    icon: Icons.explore,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PersonnelStatCard(
                    title: 'Available',
                    value: '22',
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Personnel List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            PersonnelCard(
              id: 'NPC-001',
              name: 'Prithvish Raj Shukla',
              role: 'Expedition Officer',
              station: 'Maitri Station',
              status: 'Active',
            ),

            PersonnelCard(
              id: 'NPC-002',
              name: 'Harsh Kasera',
              role: 'Logistics Officer',
              station: 'Maitri Station',
              status: 'Active',
            ),

            PersonnelCard(
              id: 'NPC-003',
              name: 'Kavya Singh',
              role: 'Research Scientist',
              station: 'Bharati Station',
              status: 'Active',
            ),

            PersonnelCard(
              id: 'NPC-004',
              name: 'Udit Pratap Singh',
              role: 'Expedition Team Member',
              station: 'Maitri Station',
              status: 'Active',
            ),

            PersonnelCard(
              id: 'NPC-005',
              name: 'Tulsi',
              role: 'Expedition Team Member',
              station: 'Maitri Station',
              status: 'Active',
            ),

            PersonnelCard(
              id: 'NPC-006',
              name: 'Bhawna Gupta',
              role: 'Research Team Member',
              station: 'Bharati Station',
              status: 'Active',
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
                'Add Personnel will be added next.',
              ),
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

// ============================================================
// PERSONNEL STAT CARD
// ============================================================

class PersonnelStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const PersonnelStatCard({
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
// PERSONNEL CARD
// ============================================================

class PersonnelCard extends StatelessWidget {
  final String id;
  final String name;
  final String role;
  final String station;
  final String status;

  const PersonnelCard({
    super.key,
    required this.id,
    required this.name,
    required this.role,
    required this.station,
    required this.status,
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
          child: const Icon(
            Icons.person,
            color: polarDark,
            size: 28,
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
            '$id\n$role\n$station',
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
              builder: (_) => PersonnelDetailsPage(
                id: id,
                name: name,
                role: role,
                station: station,
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
// PERSONNEL DETAILS
// ============================================================

class PersonnelDetailsPage extends StatelessWidget {
  final String id;
  final String name;
  final String role;
  final String station;
  final String status;

  const PersonnelDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.role,
    required this.station,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: polarVeryLight,

      appBar: AppBar(
        backgroundColor: polarBlue,
        foregroundColor: Colors.white,
        title: const Text('Personnel Details'),
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
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: polarVeryLight,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: polarDark,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: polarDeep,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    id,
                    style: const TextStyle(
                      color: polarBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: status == 'Active'
                          ? Colors.green.withValues(alpha: 0.12)
                          : polarVeryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status == 'Active'
                            ? Colors.green
                            : polarBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Personnel Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            PersonnelDetailTile(
              icon: Icons.badge,
              title: 'Personnel ID',
              value: id,
            ),

            PersonnelDetailTile(
              icon: Icons.work,
              title: 'Role',
              value: role,
            ),

            PersonnelDetailTile(
              icon: Icons.location_on,
              title: 'Current Station',
              value: station,
            ),

            const PersonnelDetailTile(
              icon: Icons.explore,
              title: 'Assigned Expedition',
              value: 'Antarctic Expedition 2026',
            ),

            const PersonnelDetailTile(
              icon: Icons.phone,
              title: 'Contact',
              value: '+91 XXXXX XXXXX',
            ),

            const PersonnelDetailTile(
              icon: Icons.calendar_month,
              title: 'Deployment Date',
              value: '15 January 2026',
            ),

            const SizedBox(height: 25),

            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: polarDeep,
              ),
            ),

            const SizedBox(height: 15),

            PersonnelActionButton(
              icon: Icons.assignment,
              title: 'View Assignments',
            ),

            PersonnelActionButton(
              icon: Icons.explore,
              title: 'View Expedition',
            ),

            PersonnelActionButton(
              icon: Icons.edit,
              title: 'Edit Personnel',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL TILE
// ============================================================

class PersonnelDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PersonnelDetailTile({
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
// ACTION BUTTON
// ============================================================

class PersonnelActionButton extends StatelessWidget {
  final IconData icon;
  final String title;

  const PersonnelActionButton({
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