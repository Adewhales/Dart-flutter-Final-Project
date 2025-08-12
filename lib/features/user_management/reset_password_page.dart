import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatelessWidget {
  final String username;

  const ResetPasswordPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Reset password for: $username',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text('Reset Password'),
              onPressed: () async {
                final newPassword = newPasswordController.text.trim();

                if (newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password cannot be empty.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('${username}_password', newPassword);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Password reset successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
