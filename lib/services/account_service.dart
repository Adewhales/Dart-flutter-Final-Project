import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  static Future<String> getActiveAccountName(String initialName) async {
    final trimmed = initialName.trim();
    if (trimmed.isNotEmpty) return trimmed;

    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('account_name')?.trim();

    return storedName?.isNotEmpty == true ? storedName! : '';
  }

  static Future<void> saveAccountName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('account_name', name.trim());
  }

  static Future<void> clearAccountName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('account_name');
  }
}
