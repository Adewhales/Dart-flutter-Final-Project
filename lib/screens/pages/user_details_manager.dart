import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/pages/user_details.dart';

class UserDetailsManager {
  static const _superUserKey = 'account_is_super_user';
  static const _usernameKey = 'account_username';
  static const _passwordKey = 'account_password';
  final String username;
  final String password;
  final bool isSuperUser;

  UserDetailsManager({
    required this.username,
    required this.password,
    required this.isSuperUser,
  });

  static Future<void> saveUserDetailsManager(UserDetailsManager account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, account.username);
    await prefs.setString(_passwordKey, account.password);
    await prefs.setBool(_superUserKey, account.isSuperUser);
  }

  static Future<UserDetailsManager?> loadUserDetailsManager() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    final password = prefs.getString(_passwordKey);
    final isSuperUser = prefs.getBool(_superUserKey) ?? false;

    if (username != null && password != null) {
      return UserDetailsManager(
        username: username,
        password: password,
        isSuperUser: isSuperUser,
      );
    }
    return null;
  }

  Future<void> clearUserDetailsManager() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_superUserKey);
  }
}
