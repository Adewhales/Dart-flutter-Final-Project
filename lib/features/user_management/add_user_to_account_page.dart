import 'package:flutter/material.dart';
import 'package:sajomainventory/services/user_service.dart';
import 'package:sajomainventory/features/dashboard/dashboard_page.dart';

class AddUserToAccountPage extends StatefulWidget {
  const AddUserToAccountPage({super.key});

  @override
  State<AddUserToAccountPage> createState() => _AddUserToAccountPageState();
}

class _AddUserToAccountPageState extends State<AddUserToAccountPage> {
  final _emailController = TextEditingController();
  final _accountController = TextEditingController();
  String? _message;
  bool _isLoading = false;

  Future<void> _assign() async {
    final email = _emailController.text.trim();
    final account = _accountController.text.trim();

    if (email.isEmpty || account.isEmpty) {
      setState(() => _message = 'Please fill in both fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final response = await UserService.assignUserToAccount(
        email: email,
        accountName: account,
      );

      if (response.statusCode == 200) {
        setState(
            () => _message = '✅ Assigned $email to $account successfully.');
      } else {
        setState(() => _message = '❌ Failed: ${response.body}');
      }
    } catch (e) {
      setState(() => _message = '❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
      _emailController.clear();
      _accountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign User to Account'),
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
              controller: _accountController,
              decoration: const InputDecoration(labelText: 'Account Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _assign,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Assign'),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color:
                        _message!.startsWith('✅') ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
