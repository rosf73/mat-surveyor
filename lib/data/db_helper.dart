import 'dart:convert';
import 'dart:developer';

import 'package:mat_surveyors/data/dto/location.dart';
import 'package:mat_surveyors/data/dto/post.dart';
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
    log("dbPath = $dbPath");
    final path = join(dbPath, 'mat_db.db');

    log("======== open database ========");
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async { // 가장 첫 DB 생성 시 호출. 그 이후에는 onUpgrade or onDowngrade 호출.
        await db.execute(
          """
            CREATE TABLE POSTS(
              id INTEGER PRIMARY KEY,
              lat DOUBLE,
              lon DOUBLE,
              address TEXT,
              rating DOUBLE,
              review TEXT,
              pictures JSON DEFAULT('[]')
            )
          """,
        );
      },
    );
  }

  Future<void> insertToPost(double lat, double lon, String address, double rating, String review, List<String> pictures) async {
    final db = await database;
    await db.insert(
      'POSTS', // Table name
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

  Future<List<Location>> selectAllLocation() async {
    final db = await database;
    final result = await db.query('POSTS');

    return result.map((e) => Location(
      e['id'] as int,
      e['lat'] as double,
      e['lon'] as double,
      e['address'] as String,
    )).toList();
  }

  Future<List<Post>> selectAllPost() async {
    final db = await database;
    final result = await db.query('POSTS');

    return result.map((e) => Post(
      e['id'] as int,
      e['lat'] as double,
      e['lon'] as double,
      e['address'] as String,
      e['rating'] as double,
      e['review'] as String,
      (jsonDecode(e['pictures'] as String) as List<dynamic>).cast<String>(),
    )).toList();
  }

  Future<void> updatePost(int id, double rating, String address, String review, List<String> pictures) async {
    final db = await database;
    await db.update(
      'POSTS',
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
      'POSTS',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
