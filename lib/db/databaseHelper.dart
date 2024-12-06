import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('series.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);

    return await openDatabase(fullPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE series (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          genre TEXT,
          description TEXT,
          score INTEGER,
          cover TEXT
        )
      ''');
    });
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await instance.database;
    return await db.query('series');
  }
}
