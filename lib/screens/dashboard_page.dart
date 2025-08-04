import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/pages/inboundstock.dart';
import 'package:sajomainventory/screens/pages/outboundstock.dart';
import 'package:sajomainventory/screens/pages/startofday.dart';
import 'package:sajomainventory/screens/pages/endofday.dart';
import 'package:sajomainventory/screens/pages/checkstocks.dart';
import 'package:sajomainventory/screens/pages/user_management_page.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';
import 'package:sajomainventory/screens/pages/adminsettings_page.dart';
import 'package:sajomainventory/utils/auth_utils.dart';
import 'package:sajomainventory/utils/internet_utils.dart'
    hide hasInternetConnection;
import '../widgets/dashboard_card.dart';

enum UserRole { admin, manager, cashier }

class DashboardPage extends StatefulWidget {
  final String accountName;
  final bool isSuperUser;

  const DashboardPage({
    super.key,
    required this.accountName,
    required this.isSuperUser,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> accessStatus;

  @override
  void initState() {
    super.initState();
    accessStatus = _loadAccessStatus();
  }

  Future<void> refreshAccessStatus() async {
    setState(() {
      accessStatus = _loadAccessStatus();
    });
  }

  Future<Map<String, dynamic>> _loadAccessStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isStartEnabled = prefs.getBool('start_of_day_enabled') ?? false;
    final isEndCompleted = prefs.getBool('end_of_day_completed') ?? false;
    final roleString = prefs.getString('user_role') ?? 'cashier';
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleString,
      orElse: () => UserRole.cashier,
    );

    final canAccessStock = isStartEnabled && !isEndCompleted;

    return {
      'canAccessStock': canAccessStock,
      'role': role,
      'isStartEnabled': isStartEnabled,
      'isEndCompleted': isEndCompleted,
    };
  }

  static const TextStyle _cardStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  void _showAccessDenied(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Access Denied: Start of Day not activated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.accountName} Inventory Management System',
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
              'Welcome to ${widget.accountName}',
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 181, 58)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Start of Day
            DashboardCard(
                title: 'Start of Day',
                icon: Icons.play_circle_fill,
                color: Colors.green,
                style: _cardStyle,
                onTap: () async {
                  final isAuthenticated = await confirmPassword(context);
                  if (isAuthenticated) {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (_) => const StartofdayPage()),
                    );
                    if (result == true) {
                      await refreshAccessStatus(); // ✅ Refresh only if Start of Day was completed
                    }
                  }
                }),
            FutureBuilder<Map<String, dynamic>>(
              future: accessStatus,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final isStartEnabled = snapshot.data!['isStartEnabled'] as bool;
                final isEndCompleted = snapshot.data!['isEndCompleted'] as bool;

                String statusText;
                Color statusColor;

                if (isStartEnabled && !isEndCompleted) {
                  statusText = '🟢 Day Active';
                  statusColor = Colors.green;
                } else if (isEndCompleted) {
                  statusText = '🔴 Day Ended';
                  statusColor = Colors.red;
                } else {
                  statusText = '⚪ Day Not Started';
                  statusColor = Colors.grey;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                );
              },
            ),

            // Stock Features
            FutureBuilder<Map<String, dynamic>>(
              future: accessStatus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                      child: Text('Failed to load access status'));
                }

                final canAccessStock = snapshot.data!['canAccessStock'] as bool;

                void showAccessDenied() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Access Denied: Day not active or already ended')),
                  );
                }

                return Column(
                  children: [
                    DashboardCard(
                      title: 'Inbound Stock',
                      icon: Icons.download,
                      color: canAccessStock ? Colors.blue : Colors.grey,
                      style: _cardStyle,
                      onTap: canAccessStock
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const InboundStockPage()))
                          : showAccessDenied,
                    ),
                    DashboardCard(
                      title: 'Outbound Stock',
                      icon: Icons.upload,
                      color: canAccessStock ? Colors.orange : Colors.grey,
                      style: _cardStyle,
                      onTap: canAccessStock
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const OutboundStockPage()))
                          : showAccessDenied,
                    ),
                    DashboardCard(
                      title: 'Stock Checker',
                      icon: Icons.search,
                      color: canAccessStock ? Colors.teal : Colors.grey,
                      style: _cardStyle,
                      onTap: canAccessStock
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CheckstockPage()))
                          : showAccessDenied,
                    ),
                  ],
                );
              },
            ),

            // End of Day
            DashboardCard(
              title: 'End of Day',
              icon: Icons.stop_circle,
              color: Colors.red,
              style: _cardStyle,
              onTap: () async {
                final isAuthenticated = await confirmPassword(context);
                if (isAuthenticated) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('end_of_day_enabled', false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EndofDayPage()),
                  );
                }
              },
            ),

            // Admin Tools
            if (widget.isSuperUser) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Admin Tools',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 168, 45)),
              ),
              const SizedBox(height: 12),
              DashboardCard(
                title: 'User Management',
                icon: Icons.admin_panel_settings,
                color: const Color.fromARGB(255, 167, 176, 39),
                style: _cardStyle,
                onTap: () async {
                  final isAuthenticated = await confirmPassword(context);
                  if (isAuthenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const UserManagementPage()),
                    );
                  }
                },
              ),
              DashboardCard(
                title: 'Reports',
                icon: Icons.bar_chart,
                color: const Color.fromARGB(255, 171, 183, 58),
                style: _cardStyle,
                onTap: () async {
                  final isAuthenticated = await confirmPassword(context);
                  if (isAuthenticated) {
                    final connected = await hasInternetConnection();
                    if (!connected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Internet Failure: Please check your connection and try again')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportsPage()),
                    );
                  }
                },
              ),
              DashboardCard(
                title: 'Admin Settings',
                icon: Icons.settings,
                color: Colors.indigo,
                style: _cardStyle,
                onTap: () async {
                  final isAuthenticated = await confirmPassword(context);
                  if (isAuthenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminSettingsCard()),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
