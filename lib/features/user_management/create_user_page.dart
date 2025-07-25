import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Regular User';
  String? _message;

  Future<void> _createUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _message = 'Email and password are required.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email_$email', email);
    await prefs.setString('user_password_$email', password);
    await prefs.setString('user_role_$email', _selectedRole);

    setState(() => _message = 'User "$email" created as $_selectedRole.');
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: const [
                DropdownMenuItem(
                    value: 'Super User', child: Text('Super User')),
                DropdownMenuItem(
                    value: 'Regular User', child: Text('Regular User')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedRole = value);
              },
              decoration: const InputDecoration(labelText: 'User Role'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Create User'),
              onPressed: _createUser,
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
