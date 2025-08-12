import 'package:hive/hive.dart';

part 'auth_meta.g.dart';

@HiveType(typeId: 3)
class AuthMeta extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  DateTime lastLogin;

  @HiveField(2)
  String sessionToken;

  AuthMeta({
    required this.username,
    required this.lastLogin,
    required this.sessionToken,
  });
}
