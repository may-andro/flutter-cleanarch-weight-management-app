import 'dart:async';

import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/model/weight_history.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:flutter_weighter/utility/text_utility.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class AddWeightBloc {
  final _repository = Repository();
  double weight = 0;

  final _selectedWeightBehaviorSubject = PublishSubject<double>();
  Stream<double> get selectedWeightStream => _selectedWeightBehaviorSubject.stream;
  Sink<double> get selectedWeightSink => _selectedWeightBehaviorSubject.sink;

  dispose() {
    _selectedWeightBehaviorSubject.close();
  }

  Future updateUserTable(double event, Store<AppState> store) async {
    User currentUser = store.state.user;

    var differenceInWeight = event - currentUser.weight;
    currentUser.weight = event;
    currentUser.bmi = currentUser.weight / ((currentUser.height * 0.01) * (currentUser.height * 0.01));
    currentUser.fat_percentage =
        (1.20 * currentUser.bmi) + (0.23 * currentUser.age) - (10.8 * currentUser.gender) - 5.4;
    currentUser.last_updated = DateFormat.yMMMd().format(DateTime.now());

    await _repository.updateUser(currentUser).then((val) {
      store.dispatch(UpdateUserAction(user: currentUser));
      updateWeightHistoryTable(event, differenceInWeight);
    });
  }

  Future updateWeightHistoryTable(double event, double differenceInWeight) async {
    var time = DateFormat.jm().format(DateTime.now());
    var date = DateFormat.yMMMd().format(DateTime.now());

    WeightHistory weightHistory =
        WeightHistory(weight: event, difference: format(differenceInWeight), date: date, time: time);
    await _repository.insertWeightHistory(weightHistory);
  }
}
