import 'package:hive/hive.dart';

part 'account_details.g.dart';

@HiveType(typeId: 4)
class AccountDetails extends HiveObject {
  @HiveField(0)
  String accountName;

  @HiveField(1)
  String accountAddress;

  @HiveField(2)
  String accountTelephone;

  @HiveField(3)
  DateTime accountCreationDateTime;

  @HiveField(4)
  final String email;

  AccountDetails({
    required this.accountName,
    required this.accountAddress,
    required this.accountTelephone,
    required this.email,
    required this.accountCreationDateTime,
  });
}
