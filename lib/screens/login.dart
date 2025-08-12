import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/features/user_management/reset_password_page.dart';
import 'package:sajomainventory/screens/pages/landing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sajomainventory/features/user_management/confirm_password_firestore.dart';
import 'package:sajomainventory/features/user_management/user_role.dart';
import 'package:sajomainventory/services/account_service.dart'; // ✅ Import the service

class LoginPage extends StatefulWidget {
  final String accountName;
  final bool isSuperUser;

  const LoginPage({
    Key? key,
    required this.accountName,
    required this.isSuperUser,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _rememberMe = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password.';
        _isLoading = false;
      });
      return;
    }

    // ✅ Use AccountService to get the active account name
    final accountName =
        await AccountService.getActiveAccountName(widget.accountName);

    if (accountName.isEmpty) {
      setState(() {
        _errorMessage = 'Account Name is missing. Please contact admin.';
        _isLoading = false;
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(accountName)
          .get();

      if (!doc.exists) {
        setState(() {
          _errorMessage = '❌ Account "$accountName" not found.';
          _isLoading = false;
        });
        return;
      }

      final data = doc.data();
      if (data == null ||
          data['email'] != email ||
          data['password'] != password) {
        setState(() {
          _errorMessage = '❌ Invalid email or password.';
          _isLoading = false;
        });
        return;
      }

      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', true);
      }

      // ✅ Save account name for future use
      await AccountService.saveAccountName(accountName);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(
            accountName: accountName,
            isSuperUser: widget.isSuperUser,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = '❌ Login failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 246, 231),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.accountName} Login',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text('Remember Me'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 164, 183, 58),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          if (widget.isSuperUser) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordPage(
                                    username: widget.accountName),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Only super users can reset passwords.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
