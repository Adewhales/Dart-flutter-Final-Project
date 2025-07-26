import 'package:flutter/material.dart';
import 'package:sajomainventory/main.dart';
import 'package:sajomainventory/screens/pages/inboundstock.dart';
import 'package:sajomainventory/screens/pages/outboundstock.dart';
import 'package:sajomainventory/screens/pages/startofday.dart';
import 'package:sajomainventory/screens/pages/endofday.dart';
import 'package:sajomainventory/screens/pages/endofday_summary.dart';
import 'package:sajomainventory/screens/pages/checkstocks.dart';
import 'package:sajomainventory/screens/pages/user_management_page.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';
import 'package:sajomainventory/screens/pages/adminsettings_page.dart';
import '../widgets/dashboard_card.dart';

/// Dashboard page for navigating inventory features.
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
          '$accountName Inventory Management System',
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

            /// Core dashboard cards
            DashboardCard(
              title: 'Start of Day',
              icon: Icons.play_circle_fill,
              color: Colors.green,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onTap: () async {
                final isAuthenticated = await showPasswordDialog(context);
                if (!isAuthenticated) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StartofdayPage()),
                );
              },
            ),
            DashboardCard(
              title: 'Inbound Stock',
              icon: Icons.download,
              color: Colors.blue,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InboundStockPage()),
                );
              },
            ),
            DashboardCard(
              title: 'Outbound Stock',
              icon: Icons.upload,
              color: Colors.orange,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OutboundStockPage()),
                );
              },
            ),
            DashboardCard(
              title: 'Stock Checker',
              icon: Icons.search,
              color: Colors.teal,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckstockPage()),
                );
              },
            ),
            DashboardCard(
              title: 'End of Day',
              icon: Icons.stop_circle,
              color: Colors.red,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onTap: () async {
                final isAuthenticated = await showPasswordDialog(context);
                if (!isAuthenticated) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EndofDayPage()),
                );
              },
            ),

            /// Admin-only tools
            if (isSuperUser) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Admin Tools',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 160, 168, 45),
                ),
              ),
              const SizedBox(height: 12),
              DashboardCard(
                title: 'User Management',
                icon: Icons.admin_panel_settings,
                color: const Color.fromARGB(255, 167, 176, 39),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onTap: () async {
                  final isAuthenticated = await showPasswordDialog(context);
                  if (!isAuthenticated) return;
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
                color: const Color.fromARGB(255, 171, 183, 58),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onTap: () async {
                  final isAuthenticated = await showPasswordDialog(context);
                  if (!isAuthenticated) return;
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onTap: () async {
                  final isAuthenticated = await showPasswordDialog(context);
                  if (!isAuthenticated) return;
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
