import 'package:hive/hive.dart';
import 'package:sajomainventory/models/stock_record.dart';

class HiveStockHelper {
  static final Box<StockRecord> _inboundBox =
      Hive.box<StockRecord>('inbound_stock');
  static final Box<StockRecord> _outboundBox =
      Hive.box<StockRecord>('outbound_stock');

  /// ✅ Insert inbound stock record
  static Future<void> insertInboundStock({
    required String item,
    required int quantity,
    required String unit,
    required String source,
  }) async {
    final record = StockRecord(
      item: item,
      quantity: quantity,
      unit: unit,
      source: source,
      timestamp: DateTime.now(),
    );

    await _inboundBox.add(record);
  }

  /// ✅ Insert outbound stock record
  static Future<void> insertOutboundStock({
    required String item,
    required int quantity,
    required String unit,
    required String recipient,
  }) async {
    final record = StockRecord(
      item: item,
      quantity: quantity,
      unit: unit,
      source: recipient,
      timestamp: DateTime.now(),
    );

    await _outboundBox.add(record);
  }

  /// 📦 Get all inbound stock records
  static List<StockRecord> getAllInboundRecords() {
    return _inboundBox.values.toList();
  }

  /// 📤 Get today's outbound records
  static List<StockRecord> getTodayOutboundRecords() {
    final today = DateTime.now();
    return _outboundBox.values.where((record) {
      return record.timestamp.year == today.year &&
          record.timestamp.month == today.month &&
          record.timestamp.day == today.day;
    }).toList();
  }
}
