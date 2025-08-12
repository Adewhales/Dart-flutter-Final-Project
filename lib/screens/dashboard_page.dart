import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:sajomainventory/widgets/dashboard_card.dart';

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

  static const TextStyle _cardStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

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

    return {
      'canAccessStock': isStartEnabled && !isEndCompleted,
      'role': role,
      'isStartEnabled': isStartEnabled,
      'isEndCompleted': isEndCompleted,
    };
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _authenticateAndNavigate(
      BuildContext context, Widget page) async {
    final isAuthenticated =
        await confirmPasswordFirestore(context, widget.accountName);
    if (isAuthenticated) {
      final result = await Navigator.push<bool>(
          context, MaterialPageRoute(builder: (_) => page));
      if (result == true) await refreshAccessStatus();
    }
  }

  Widget _buildStatusIndicator(Map<String, dynamic> data) {
    final isStartEnabled = data['isStartEnabled'] as bool;
    final isEndCompleted = data['isEndCompleted'] as bool;

    String statusText;
    Color statusColor;

    if (isStartEnabled && !isEndCompleted) {
      statusText = '🟢 Day Active (Day Opened)';
      statusColor = Colors.green;
    } else if (isEndCompleted) {
      statusText = '🔴 Day Ended, Please wait for Day Opening';
      statusColor = Colors.red;
    } else {
      statusText = '⚪ Day Not Started';
      statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
      ),
    );
  }

  Widget _buildStockCards(bool canAccessStock) {
    void denyAccess() =>
        _showSnack(context, 'Access Denied: Day not active or already ended');

    return Column(
      children: [
        DashboardCard(
          title: 'Inbound Stock',
          icon: Icons.download,
          color: canAccessStock ? Colors.blue : Colors.grey,
          style: _cardStyle,
          onTap: canAccessStock
              ? () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const InboundStockPage()))
              : denyAccess,
        ),
        DashboardCard(
          title: 'Outbound Stock',
          icon: Icons.upload,
          color: canAccessStock ? Colors.orange : Colors.grey,
          style: _cardStyle,
          onTap: canAccessStock
              ? () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OutboundStockPage()))
              : denyAccess,
        ),
        DashboardCard(
          title: 'Stock Checker',
          icon: Icons.search,
          color: canAccessStock ? Colors.teal : Colors.grey,
          style: _cardStyle,
          onTap: canAccessStock
              ? () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CheckstockPage()))
              : denyAccess,
        ),
      ],
    );
  }

  Widget _buildAdminTools() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        const Text(
          'Admin Tools',
          style: TextStyle(
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
          style: _cardStyle,
          onTap: () =>
              _authenticateAndNavigate(context, const UserManagementPage()),
        ),
        DashboardCard(
          title: 'Reports',
          icon: Icons.bar_chart,
          color: const Color.fromARGB(255, 171, 183, 58),
          style: _cardStyle,
          onTap: () async {
            final isAuthenticated =
                await confirmPasswordFirestore(context, widget.accountName);
            if (isAuthenticated) {
              final connected = await hasInternetConnection();
              if (!connected) {
                _showSnack(context,
                    'Internet Failure: Please check your connection and try again');
                return;
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReportsPage()));
            }
          },
        ),
        DashboardCard(
          title: 'Admin Settings',
          icon: Icons.settings,
          color: Colors.indigo,
          style: _cardStyle,
          onTap: () =>
              _authenticateAndNavigate(context, const AdminSettingsCard()),
        ),
      ],
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
                color: Color.fromARGB(255, 183, 181, 58),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Start of Day
            DashboardCard(
              title: 'Start of Day',
              icon: Icons.play_circle_fill,
              color: Colors.green,
              style: _cardStyle,
              onTap: () =>
                  _authenticateAndNavigate(context, const StartofdayPage()),
            ),

            // Status & Stock Access
            FutureBuilder<Map<String, dynamic>>(
              future: accessStatus,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final data = snapshot.data!;
                return Column(
                  children: [
                    _buildStatusIndicator(data),
                    _buildStockCards(data['canAccessStock'] as bool),
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
                final isAuthenticated =
                    await confirmPasswordFirestore(context, widget.accountName);
                if (isAuthenticated) {
                  await FirebaseFirestore.instance
                      .collection('accounts')
                      .doc(widget.accountName)
                      .update({'end_of_day_completed': true});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const EndofDayPage()));
                }
              },
            ),

            // Admin Tools
            if (widget.isSuperUser) _buildAdminTools(),
          ],
        ),
      ),
    );
  }
}
