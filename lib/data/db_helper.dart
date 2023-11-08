import 'dart:convert';

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
      version: 2,
      onCreate: (db, version) async { // 가장 첫 DB 생성 시 호출. 그 이후에는 onUpgrade or onDowngrade 호출.
        await db.execute(
          "CREATE TABLE POST("
              "id INTEGER PRIMARY KEY,"
              "lat DOUBLE,"
              "lon DOUBLE,"
              "address TEXT,"
              "rating DOUBLE,"
              "review TEXT,"
              "pictures JSON DEFAULT('[]'))",
        );
      },
    );
  }

  Future<void> insertToPost(double lat, double lon, String address, double rating, String review, List<String> pictures) async {
    final db = await database;
    await db.insert(
      'POST', // Table name
      { // Data
        'lat': lat,
        'lon': lon,
        'rating': rating,
        'address': address,
        'review': review,
        'pictures': jsonEncode(pictures),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Duplicated Data Strategy
    );
  }

  Future<List<Map<String, dynamic>>> selectAllPost() async {
    final db = await database;
    return await db.query('POST');
  }

  Future<void> updatePost(int id, double rating, String address, String review, List<String> pictures) async {
    final db = await database;
    await db.update(
      'POST',
      {
        'rating': rating,
        'address': address,
        'review': review,
        'pictures': jsonEncode(pictures),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePost(int id) async {
    final db = await database;
    await db.delete(
      'POST',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
