// lib/utils/auth_utils.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Checks if the device has internet connection.
Future<bool> hasInternetConnection() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

/// Generates a 4-digit start code and stores it.
Future<String> generateAndStoreStartCode() async {
  final prefs = await SharedPreferences.getInstance();
  final code = (Random().nextInt(9000) + 1000).toString();
  await prefs.setString('start_of_day_code', code);
  await prefs.setBool('start_of_day_enabled', false);
  return code;
}

/// Prompts user to enter their account password.
Future<bool> confirmPasswordFirestore(
    BuildContext context, String accountName) async {
  final passwordController = TextEditingController();
  bool confirmed = false;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Password'),
      content: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Enter your password'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final doc = await FirebaseFirestore.instance
                .collection('accounts')
                .doc(accountName)
                .get();

            final storedPassword = doc.data()?['password'];
            if (storedPassword == passwordController.text) {
              confirmed = true;
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('❌ Incorrect password'),
                    backgroundColor: Colors.red),
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );

  return confirmed;
}
