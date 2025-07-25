import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _message;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text;

    final prefs = await SharedPreferences.getInstance();
    final existingEmail = prefs.getString('user_email_$email');

    if (existingEmail == null) {
      setState(() => _message = 'User not found.');
      return;
    }

    await prefs.setString('user_password_$email', newPassword);
    setState(() => _message = 'Password reset for $email.');
    _emailController.clear();
    _newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'User Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text('Reset Password'),
              onPressed: _resetPassword,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_message!,
                    style: const TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}
