import 'package:flutter/material.dart';
import 'package:sajomainventory/features/user_management/add_user_to_account_page.dart';
import 'package:sajomainventory/features/user_management/create_user_page.dart';
import 'package:sajomainventory/features/user_management/reset_password_page.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';
import 'package:sajomainventory/main.dart';
import 'package:sajomainventory/utils/auth_utils.dart'; // for generateAndStoreStartCode()

class AdminSettingsCard extends StatelessWidget {
  const AdminSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),

            // Reset Password
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text("Reset User Password"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
                );
              },
            ),
            const SizedBox(height: 8),

            // Reports
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text("Run Customized Reports"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportsPage()),
                );
              },
            ),
            const SizedBox(height: 8),

            // Add users to existing account
            ElevatedButton.icon(
              icon: const Icon(Icons.group_add),
              label: const Text("Add Users to Accounts"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddUserToAccountPage()),
                );
              },
            ),
            const SizedBox(height: 8),

            // Builder ensures local context for SnackBar
            Builder(
              builder: (localContext) {
                return Column(
                  children: [
                    // Generate Code
                    ElevatedButton.icon(
                      icon: const Icon(Icons.key),
                      label: const Text("Generate Start/End of Day Code"),
                      onPressed: () async {
                        try {
                          final code = await generateAndStoreStartCode();
                          ScaffoldMessenger.of(localContext).showSnackBar(
                            SnackBar(content: Text('Generated Code: $code')),
                          );
                        } catch (e) {
                          print('Failed to generate code: $e');
                          ScaffoldMessenger.of(localContext).showSnackBar(
                            const SnackBar(
                                content: Text('Error generating code')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),

                    // Create new users & assign roles
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text("Create Users & Assign Roles"),
                      onPressed: () {
                        Navigator.push(
                          localContext,
                          MaterialPageRoute(
                              builder: (_) => const CreateUserPage()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
