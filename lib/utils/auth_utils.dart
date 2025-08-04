// lib/utils/auth_utils.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
Future<bool> confirmPassword(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final storedPassword = prefs.getString('account_password') ?? '';
  final controller = TextEditingController();
  String? error;

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Enter Account Password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: error,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim() == storedPassword) {
                  Navigator.pop(context, true);
                } else {
                  setState(() => error = 'Incorrect password');
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      });
    },
  ).then((value) => value ?? false);
}

/// Prompts user to enter the Start of Day code.
Future<bool> showStartOfDayDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final storedCode = prefs.getString('start_of_day_code') ?? '';
  final controller = TextEditingController();
  String? error;

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Enter Start of Day Code'),
          content: TextField(
            controller: controller,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '4-digit Code',
              errorText: error,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim() == storedCode) {
                  await prefs.setBool('start_of_day_enabled', true);
                  Navigator.pop(context, true);
                } else {
                  setState(() => error = 'Incorrect code');
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      });
    },
  ).then((value) => value ?? false);
}
