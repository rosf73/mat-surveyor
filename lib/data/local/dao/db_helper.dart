import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:mat_surveyors/data/local/dto/location.dart';
import 'package:mat_surveyors/data/local/dto/post.dart';
import 'package:mat_surveyors/data/memory/map_data.dart';
import 'package:mat_surveyors/utils/encoding_functions.dart';
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

  Future<void> clearPost() async {
    final db = await database;
    await db.delete(
      'POSTS',
      where: 'id > ?',
      whereArgs: [0],
    );
    MapData().clearPost();
  }

  Future<void> insertToPost(double lat, double lon, String address, double rating, String review, List<Uint8List> pictures) async {
    final db = await database;
    final id = await db.insert(
      'POSTS', // Table name
      { // Data
        'lat': lat,
        'lon': lon,
        'rating': rating,
        'address': address,
        'review': review,
        'pictures': jsonEncode(encodeToBase64List(pictures)),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Duplicated Data Strategy
    );
    MapData().insertPost(id, lat, lon, address, rating, review, pictures); // add cached data
  }

  Future<List<Location>> selectAllLocation() async {
    final cachedData = MapData().locations;
    if (cachedData.isNotEmpty) { // If cached data already exist, do not fetch it.
      log("location is already cached = $cachedData");
      return cachedData;
    }

    final db = await database;
    final temp = (await db.query('POSTS'));
    final posts = temp.map((e) => Post(
      e['id'] as int,
      e['lat'] as double,
      e['lon'] as double,
      e['address'] as String,
      e['rating'] as double,
      e['review'] as String,
      (jsonDecode(e['pictures'] as String) as List<dynamic>).map((e) => decodeFromBase64(e.toString())).toList(),
    ));
    final result = posts.map((e) => Location(e.id, e.lat, e.lon, e.address,)).toList();

    MapData().posts = posts.toList();
    return result;
  }

  Future<List<Post>> selectAllPost() async {
    final cachedData = MapData().posts;
    if (cachedData.isNotEmpty) { // If cached data already exist, do not fetch it.
      log("posts is already cached = $cachedData");
      return cachedData;
    }

    final db = await database;
    final result = (await db.query('POSTS')).map((e) => Post(
      e['id'] as int,
      e['lat'] as double,
      e['lon'] as double,
      e['address'] as String,
      e['rating'] as double,
      e['review'] as String,
      (jsonDecode(e['pictures'] as String) as List<dynamic>).map((e) => decodeFromBase64(e)).toList(),
    )).toList();

    MapData().posts = result;
    return result;
  }

  Future<void> updatePost(int id, double rating, String address, String review, List<Uint8List> pictures) async {
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
    MapData().updatePost(id, rating, address, review, pictures); // modify cached data
  }

  Future<void> deletePost(int id) async {
    final db = await database;
    await db.delete(
      'POSTS',
      where: 'id = ?',
      whereArgs: [id],
    );
    MapData().deletePost(id); // remove cached data
  }
}
