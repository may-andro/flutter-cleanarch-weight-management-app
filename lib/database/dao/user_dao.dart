

import 'package:flutter_weighter/model/user.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class UserDao{
	final dbProvider = DatabaseProvider.dbProvider;

	// Insert Operation: Insert a user object to database
	Future<int> insertUser(User user) async {
		final db = await dbProvider.database;
		var result = await db.insert(userTable, user.toJson());
		return result;
	}

	// Update Operation: Update a User object and save it to database
	Future<int> updateUser(User user) async {
		final db = await dbProvider.database;
		var result = await db.update(userTable, user.toJson(), where: '$columnName = ?', whereArgs: [user.name]);
		return result;
	}

	// Delete Operation: Delete a User object from database
	Future<int> deleteUser(String name) async {
		final db = await dbProvider.database;
		int result = await db.rawDelete('DELETE FROM $userTable WHERE $columnName = $name');
		return result;
	}

	// Get number of User objects in database
	Future<int> getCount() async {
		final db = await dbProvider.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $userTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Fetch Operation: Get all Users objects from database
	Future<User> getUser() async {
		final db = await dbProvider.database;
		var result = await db.query(userTable, orderBy: '$columnId ASC');
		return User.fromJson(result[0]);
	}

	// Delete Operation: Delete a User object from database
	Future<int> deleteAllUser() async {
		final db = await dbProvider.database;
		int result = await db.delete(userTable);
		return result;
	}
}