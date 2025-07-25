import 'package:flutter/material.dart';
import 'package:sajomainventory/services/user_service.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
          title: const Text('All Users'), backgroundColor: Colors.deepPurple),
      body: FutureBuilder<List<Map<String, String>>>(
        future: userService.getAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final users = snapshot.data!;
          if (users.isEmpty)
            return const Center(child: Text('No users found.'));

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user['email']!),
                subtitle: Text('Role: ${user['role']}'),
              );
            },
          );
        },
      ),
    );
  }
}
