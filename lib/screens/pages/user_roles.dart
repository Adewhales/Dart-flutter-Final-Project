import 'package:hive/hive.dart';

part 'user_roles.g.dart';

@HiveType(typeId: 1)
class UserRole extends HiveObject {
  @HiveField(0)
  String roleName;

  @HiveField(1)
  List<String> permissions;

  UserRole({required this.roleName, required this.permissions});
}
// TODO Implement this library.
