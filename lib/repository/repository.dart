import 'package:flutter_weighter/database/dao/user_dao.dart';
import 'package:flutter_weighter/database/dao/weight_history_dao.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/model/weight_history.dart';

class Repository{
	final userDao = UserDao();
	final weightHistoryDao = WeightHistoryDao();

	Future getCurrentUser() => userDao.getUser();

	Future insertUser(User user) => userDao.insertUser(user);

	Future updateUser(User user) => userDao.updateUser(user);

	Future deleteUserByName(String name) => userDao.deleteUser(name);

	Future deleteAllUser() => userDao.deleteAllUser();

	Future getUserCount() => userDao.getCount();

	Future getWeightHistoryList() => weightHistoryDao.getWeightHistoryList();

	Future insertWeightHistory(WeightHistory weightHistory) => weightHistoryDao.insertWeightHistory(weightHistory);

	Future getTotalHistoryCount() => weightHistoryDao.getHistoryCount();

	Future deleteAllWeightHistory() => weightHistoryDao.deleteAllHistory();
}