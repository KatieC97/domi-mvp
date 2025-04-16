import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("Local database not supported on web.");
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'domi_inventory.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE items (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
location TEXT NOT NULL,
quantity INTEGER NOT NULL
)
''');

    await db.execute('''
CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
email TEXT NOT NULL UNIQUE,
password TEXT NOT NULL
)
''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    if (kIsWeb) return 0;
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    if (kIsWeb) return null; // Web SQLite unsupported
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertItem(Map<String, dynamic> item) async {
    if (kIsWeb) return 0;
    final db = await database;
    return await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    if (kIsWeb) return []; // fallback for Chrome
    final db = await database;
    return await db.query('items');
  }

  Future<void> close() async {
    if (kIsWeb) return;
    final db = await database;
    db.close();
  }
}
