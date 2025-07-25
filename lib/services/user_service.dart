import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl = 'https://your-api-url.com/api/users';

  /// Encrypts the password using SHA-256
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Registers a new user
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

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }

  /// Assigns a user to an account using email and account name
  static Future<http.Response> assignUserToAccount({
    required String email,
    required String accountName,
  }) async {
    final body = jsonEncode({
      'email': email,
      'accountName': accountName,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/assign'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }

  /// Logs in a user
  static Future<http.Response> loginUser({
    required String email,
    required String password,
  }) async {
    final encryptedPassword = encryptPassword(password);

    final body = jsonEncode({
      'email': email,
      'password': encryptedPassword,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }

  /// Fetches user profile by ID
  static Future<http.Response> getUserProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }

  /// Updates user profile
  static Future<http.Response> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    final body = jsonEncode(updates);

    final response = await http.put(
      Uri.parse('$_baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response;
  }
}
