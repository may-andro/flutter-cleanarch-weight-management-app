import 'package:flutter_weighter/model/weight_history.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class WeightHistoryDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> insertWeightHistory(WeightHistory weightHistory) async {
    final db = await dbProvider.database;
    var result = await db.insert(weightHistoryTable, weightHistory.toJson());
    return result;
  }

  // Get number of User objects in database
  Future<int> getHistoryCount() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $weightHistoryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all Users objects from database
  Future<List<WeightHistory>> getWeightHistoryList() async {
    final db = await dbProvider.database;
    var result = await db.query(weightHistoryTable, orderBy: '$columnId ASC');
    List<WeightHistory> list = List();
    result.forEach((item) {
      list.add(WeightHistory.fromJson(item));
    });
    return list;
  }

  // Delete Operation: Delete a User object from database
  Future<int> deleteAllHistory() async {
	  final db = await dbProvider.database;
	  int result = await db.delete(weightHistoryTable);
	  return result;
  }
}
