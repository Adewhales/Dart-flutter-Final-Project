import 'package:hive/hive.dart';

part 'stock_record.g.dart';

@HiveType(typeId: 2)
class StockRecord extends HiveObject {
  @HiveField(0)
  String item;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  String unit;

  @HiveField(3)
  String source;

  @HiveField(4)
  DateTime timestamp;

  StockRecord({
    required this.item,
    required this.quantity,
    required this.unit,
    required this.source,
    required this.timestamp,
  });
}
