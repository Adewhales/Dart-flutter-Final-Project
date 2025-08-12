import 'package:hive/hive.dart';

part 'user_details.g.dart';

@HiveType(typeId: 5)
class UserDetails extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  bool isSuperUser;

  UserDetails({
    required this.username,
    required this.password,
    required this.isSuperUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'isSuperUser': isSuperUser,
    };
  }

  static UserDetails fromMap(Map<String, dynamic> map) {
    return UserDetails(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      isSuperUser: map['isSuperUser'] ?? false,
    );
  }
}
