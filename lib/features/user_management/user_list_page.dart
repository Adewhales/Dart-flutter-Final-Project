import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/screens/pages/user_details.dart'; // adjust path if needed

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Box<UserDetails> userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserDetails>('users_details');
  }

  void _editUser(UserDetails user) {
    final passwordController = TextEditingController(text: user.password);
    bool isSuperUser = user.isSuperUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${user.username}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: isSuperUser,
                  onChanged: (value) {
                    setState(() {
                      isSuperUser = value ?? false;
                    });
                  },
                ),
                const Text('Is Super User'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              user.password = passwordController.text.trim();
              user.isSuperUser = isSuperUser;
              await user.save();

              Navigator.pop(context);
              setState(() {}); // refresh list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ User updated.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(String username) async {
    await userBox.delete(username);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ User "$username" deleted.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = userBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: const Color.fromARGB(255, 163, 161, 10),
      ),
      body: users.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(user.username),
                    subtitle:
                        Text(user.isSuperUser ? 'Super User' : 'Standard User'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editUser(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user.username),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
