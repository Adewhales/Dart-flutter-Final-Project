import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import 'package:sajomainventory/screens/pages/user_management_page.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';

class DashboardPage extends StatelessWidget {
  final String accountName;
  final bool isAdmin;

  const DashboardPage({
    super.key,
    required this.accountName,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$accountName Dashboard'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.indigo.shade50,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text(
              'Welcome to $accountName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            DashboardCard(
              title: 'Start of Day',
              icon: Icons.play_circle_fill,
              color: Colors.green,
              onTap: () {
                // Navigate to Start of Day page
              },
            ),
            DashboardCard(
              title: 'Inbound Stock',
              icon: Icons.download,
              color: Colors.blue,
              onTap: () {
                // Navigate to Inbound Stock page
              },
            ),
            DashboardCard(
              title: 'Outbound Stock',
              icon: Icons.upload,
              color: Colors.orange,
              onTap: () {
                // Navigate to Outbound Stock page
              },
            ),
            DashboardCard(
              title: 'Stock Checker',
              icon: Icons.search,
              color: Colors.teal,
              onTap: () {
                // Navigate to Stock Checker page
              },
            ),
            DashboardCard(
              title: 'End of Day',
              icon: Icons.stop_circle,
              color: Colors.red,
              onTap: () {
                // Navigate to End of Day page
              },
            ),
            if (isAdmin) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Admin Tools',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
              ),
              const SizedBox(height: 12),
              DashboardCard(
                title: 'User Management',
                icon: Icons.admin_panel_settings,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UserManagementPage()),
                  );
                },
              ),
              DashboardCard(
                title: 'Reports',
                icon: Icons.bar_chart,
                color: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportsPage()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
