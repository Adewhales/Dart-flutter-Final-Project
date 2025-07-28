import 'package:flutter/material.dart';
import 'package:sajomainventory/features/user_management/add_user_to_account_page.dart';
import 'package:sajomainventory/features/user_management/create_user_page.dart';
import 'package:sajomainventory/features/user_management/reset_password_page.dart';
import 'package:sajomainventory/features/user_management/user_list_page.dart';
import 'create_user_page.dart';
import 'reset_password_page.dart';
import 'add_user_to_account_page.dart';
import 'user_list_page.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management's Dashboard"),
        backgroundColor: const Color.fromARGB(255, 163, 161, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Users',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Create User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 218, 219, 119),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text('Reset Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 217, 224, 116),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.group_add),
              label: const Text('Assign User to Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 224, 230, 139),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddUserToAccountPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('View All Users'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 211, 209, 113),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserListPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
