import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get database async { // Get Database
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async { // Init Database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mat_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // TODO : Create Table
      },
    );
  }
}
