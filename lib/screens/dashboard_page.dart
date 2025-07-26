import 'package:flutter/material.dart';
import 'package:sajomainventory/screens/pages/user_management_page.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';
import 'package:sajomainventory/screens/pages/adminsettings_page.dart';
import '../widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  final String accountName;
  final bool isSuperUser;

  const DashboardPage({
    super.key,
    required this.accountName,
    required this.isSuperUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$accountName Inventory Management System",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 175, 183, 58),
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.deepPurple.shade50,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text(
              'Welcome to $accountName',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 183, 181, 58),
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
            if (isSuperUser) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Admin Tools',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
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
              DashboardCard(
                title: 'Admin Settings',
                icon: Icons.settings,
                color: Colors.indigo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminSettingsCard()),
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
