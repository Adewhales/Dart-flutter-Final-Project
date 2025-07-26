import 'package:flutter/material.dart';
import 'package:sajomainventory/services/user_service.dart';

class AddUserToAccountPage extends StatefulWidget {
  const AddUserToAccountPage({super.key});

  @override
  State<AddUserToAccountPage> createState() => _AddUserToAccountPageState();
}

class _AddUserToAccountPageState extends State<AddUserToAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  String? _message;
  bool _isLoading = false;

  Future<void> _assign() async {
    final email = _emailController.text.trim();
    final account = _accountController.text.trim();

    if (email.isEmpty || account.isEmpty) {
      setState(() => _message = '⚠️ Please fill in both fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await UserService.assignUserToAccount(email, account);
      setState(() => _message = '✅ Assigned $email to $account successfully.');
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
        backgroundColor: const Color.fromARGB(255, 183, 181, 58),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'User Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accountController,
              decoration: const InputDecoration(
                labelText: 'Account Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _assign,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 183, 181, 58),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Assign',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _message!,
                  style: TextStyle(
                    fontSize: 16,
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
