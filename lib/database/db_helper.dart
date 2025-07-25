import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sajoma_inventory.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE inbound_stock (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item TEXT,
            quantity INTEGER,
            unit TEXT,
            source TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE outbound_stock (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item TEXT,
            quantity INTEGER,
            unit TEXT,
            recipient TEXT
          )
        ''');
      },
    );
  }

  // Inbound stock
  static Future<bool> insertStock({
    required String item,
    required int quantity,
    required String unit,
    required String source,
  }) async {
    try {
      final db = await database; // Your database initialization method

      // Optional: check for duplicate item name if needed
      final existing = await db.query(
        'incoming_stock',
        where: 'item = ?',
        whereArgs: [item],
      );

      if (existing.isNotEmpty) {
        // You may decide to block duplicates or update existing record
        return false;
      }

      await db.insert(
        'incoming_stock',
        {
          'item': item,
          'quantity': quantity,
          'unit': unit,
          'source': source,
          'timestamp': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm:
            ConflictAlgorithm.replace, // You can change this behavior
      );

      return true;
    } catch (e) {
      // Log error or handle exception
      print('Insert failed: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('inbound_stock');
  }

  static Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('inbound_stock', where: 'id = ?', whereArgs: [id]);
  }

  // Outbound stock
  static Future<void> insertOutboundStock({
    required String item,
    required int quantity,
    required String unit,
    required String recipient,
  }) async {
    final db = await database;
    await db.insert('outbound_stock', {
      'item': item,
      'quantity': quantity,
      'unit': unit,
      'recipient': recipient,
    });
  }

  static Future<List<Map<String, dynamic>>> getOutboundItems() async {
    final db = await database;
    return await db.query('outbound_stock');
  }

  static Future<int> deleteOutboundItem(int id) async {
    final db = await database;
    return await db.delete('outbound_stock', where: 'id = ?', whereArgs: [id]);
  }

  static Future getDatabase() async {}
}
