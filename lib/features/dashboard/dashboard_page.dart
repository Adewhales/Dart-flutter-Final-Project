import 'package:flutter/material.dart';
import 'package:sajomainventory/services/user_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage(
      {Key? key, required String accountName, required bool isSuperUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to the Dashboard!'),
            // Add widgets like stats, charts, navigation buttons here
          ],
        ),
      ),
    );
  }
}
