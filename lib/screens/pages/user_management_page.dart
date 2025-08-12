import 'package:flutter/material.dart';
import 'package:sajomainventory/features/user_management/create_user_page.dart';
import 'package:sajomainventory/features/user_management/reset_password_page.dart';
import 'package:sajomainventory/features/user_management/user_list_page.dart';
import 'package:sajomainventory/screens/pages/user_roles.dart';
import 'package:sajomainventory/screens/pages/item_management_page.dart';

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
                final usernameController = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Enter Username'),
                    content: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final username = usernameController.text.trim();
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ResetPasswordPage(username: username),
                            ),
                          );
                        },
                        child: const Text('Proceed'),
                      ),
                    ],
                  ),
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
                  MaterialPageRoute(builder: (_) => const CreateUserPage()),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text('Manage Item Catalog'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 215, 230, 180),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ItemManagementPage()),
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
