import 'package:hive/hive.dart';

part 'login_cred.g.dart';

@HiveType(typeId: 2)
class LoginCred extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  DateTime createdAt;

  LoginCred({
    required this.username,
    required this.password,
    required this.createdAt,
  });
}
