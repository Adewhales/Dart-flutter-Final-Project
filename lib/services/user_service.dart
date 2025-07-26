import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userListKey = 'user_list';
  static const String _baseUrl =
      'https://your-api-url.com/api/users'; // Replace with your actual API

  // 🔐 Encrypt password using SHA-256
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // 🧑 Add a new user locally
  static Future<void> addUser(
      String email, String password, String role) async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = encryptPassword(password);

    await prefs.setString('user_email_$email', email);
    await prefs.setString('user_password_$email', encrypted);
    await prefs.setString('user_role_$email', role);

    final users = prefs.getStringList(_userListKey) ?? [];
    if (!users.contains(email)) {
      users.add(email);
      await prefs.setStringList(_userListKey, users);
    }
  }

  // 📋 Get all users and their roles
  static Future<List<Map<String, String>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmails = prefs.getStringList(_userListKey) ?? [];

    return userEmails.map((email) {
      final role = prefs.getString('user_role_$email') ?? 'Unknown';
      return {'email': email, 'role': role};
    }).toList();
  }

  // 🔐 Validate login credentials
  static Future<bool> validateUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('user_password_$email');
    return stored == encryptPassword(password);
  }

  // 🔄 Reset password
  static Future<void> resetPassword(String email, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = encryptPassword(newPassword);
    await prefs.setString('user_password_$email', encrypted);
  }

  // 🏢 Assign user to account
  static Future<void> assignUserToAccount(
      String email, String accountName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_account_$email', accountName);
  }

  // 🌐 Register user via API
  static Future<http.Response> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final encryptedPassword = encryptPassword(password);

    final body = jsonEncode({
      'username': username,
      'email': email,
      'password': encryptedPassword,
    });

    return await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  // 🌐 Login user via API
  static Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    final encryptedPassword = encryptPassword(password);

    final body = jsonEncode({
      'email': email,
      'password': encryptedPassword,
    });

    return await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  // 🌐 Assign user to account via API
  static Future<http.Response> assignUserToAccountRemote({
    required String email,
    required String accountName,
  }) async {
    final body = jsonEncode({
      'email': email,
      'accountName': accountName,
    });

    return await http.post(
      Uri.parse('$_baseUrl/assign'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  // 🌐 Get user profile
  static Future<http.Response> getUserProfile(String userId) async {
    return await http.get(
      Uri.parse('$_baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // 🌐 Update user profile
  static Future<http.Response> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    final body = jsonEncode(updates);

    return await http.put(
      Uri.parse('$_baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
