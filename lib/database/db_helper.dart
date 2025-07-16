import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sajoma_inventory.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE inventory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  // Insert data
  static Future<int> insertItem(String name, int quantity) async {
    final db = await database;
    return await db.insert('inventory', {
      'name': name,
      'quantity': quantity,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Get all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('inventory');
  }

  // Delete item
  static Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
  }
}
