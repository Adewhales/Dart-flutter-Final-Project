import 'package:flutter/material.dart';
import 'package:sajomainventory/services/user_service.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: const Color.fromARGB(255, 175, 183, 58),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: UserService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final users = snapshot.data;

          if (users == null || users.isEmpty) {
            return const Center(
              child: Text(
                'No users found.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final email = user['email'] ?? 'Unknown';
              final role = user['role'] ?? 'N/A';

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(email),
                subtitle: Text('Role: $role'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          );
        },
      ),
    );
  }
}
