import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final userTable = 'user_table';
final columnId = '_id';
final columnName = 'name';
final columnGender = 'gender';
final columnAge = 'age';
final columnWeight = 'weight';
final columnHeight = 'height';
final columnBmi = 'bmi';
final columnFatPercentage = 'fat_percentage';
final columnCreatedDate = 'created_date';
final columnLastUpdated = 'last_updated';

final weightHistoryTable = 'weight_history_table';
final columnHistoryWeight = 'history_weight';
final columnHistoryWeightDifference = 'history_weight_difference';
final columnHistoryDate = 'history_date';
final columnHistoryTime = 'history_time';

final _databaseName = "weighter.db";

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  static Database _database;

  static final _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _databaseName;

    // Open/create the database at a given path
    var database = await openDatabase(path, version: _databaseVersion, onCreate: _createDb, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void _createDb(Database database, int version) async {
    await database.execute('CREATE TABLE $userTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnName TEXT NOT NULL, '
        '$columnGender INTEGER NOT NULL, '
        '$columnAge INTEGER NOT NULL, '
        '$columnWeight REAL NOT NULL, '
        '$columnHeight REAL NOT NULL, '
        '$columnBmi REAL NOT NULL, '
        '$columnFatPercentage REAL NOT NULL, '
        '$columnCreatedDate TEXT NOT NULL, '
        '$columnLastUpdated TEXT NOT NULL'
        ')');

    await database.execute('CREATE TABLE $weightHistoryTable ( '
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnHistoryWeight REAL NOT NULL, '
        '$columnHistoryWeightDifference TEXT NOT NULL, '
        '$columnHistoryDate TEXT NOT NULL, '
        '$columnHistoryTime TEXT NOT NULL'
        ')');
  }

}
