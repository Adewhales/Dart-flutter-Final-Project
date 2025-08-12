import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _error;
  bool _isLoading = false;

  Future<void> _saveAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();

    if ([name, email, password, address, phone].any((field) => field.isEmpty)) {
      setState(() => _error = "All fields are required.");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(name)
          .get();

      if (doc.exists) {
        setState(() =>
            _error = "Inventory name already exists. Redirecting to login...");
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(accountName: name, isSuperUser: false),
          ),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('accounts').doc(name).set({
        'email': email,
        'password': password,
        'address': address,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('account_name', name);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(accountName: name, isSuperUser: true),
        ),
      );
    } catch (e) {
      setState(() => _error = "❌ Failed to save account: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 223, 214),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Personalize Your Inventory Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 1, 24),
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Inventory Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Inventory Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telephone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color.fromARGB(255, 161, 230, 226),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _saveAccount,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
