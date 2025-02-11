import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthStorage {
  static final AuthStorage _instance = AuthStorage._internal();
  static Database? _database;

  factory AuthStorage() {
    return _instance;
  }

  AuthStorage._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE auth (id INTEGER PRIMARY KEY, token TEXT)',
        );
      }
    );
  }

  Future<void> saveToken(String token) async {
    final db = await database;
    await db.insert(
      'auth',
      {'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getToken() async {
    final db = await database;
    final result = await db.query('auth');
    if (result.isNotEmpty) {
      return result.first['token'] as String?;
    }
    return null;
  }

  Future<void> deleteToken() async {
    final db = await database;
    await db.delete('auth');
  }
}