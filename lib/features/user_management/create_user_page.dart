import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/screens/pages/user_details.dart'; // adjust path if needed

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSuperUser = false;
  String? _errorMessage;

  Future<void> _createUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Username and password cannot be empty.';
      });
      return;
    }

    final userBox = Hive.box<UserDetails>('users_details');

    if (userBox.containsKey(username)) {
      setState(() {
        _errorMessage = 'User "$username" already exists.';
      });
      return;
    }

    final newUser = UserDetails(
      username: username,
      password: password,
      isSuperUser: _isSuperUser,
    );

    await userBox.put(username, newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ User "$username" created successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // go back to dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New User'),
        backgroundColor: const Color.fromARGB(255, 163, 161, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isSuperUser,
                  onChanged: (value) {
                    setState(() {
                      _isSuperUser = value ?? false;
                    });
                  },
                ),
                const Text('Is Super User'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Create User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 164, 183, 58),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _createUser,
            ),
          ],
        ),
      ),
    );
  }
}
