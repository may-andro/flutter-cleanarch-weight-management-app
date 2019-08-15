import 'dart:async';

import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/model/weight_history.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class OnBoardingBloc {
  //String to store navigationId
  int currentPage = NAVIGATE_TO_WELCOME_TAB;

  String name;
  int genderCode = GENDER_MALE_CODE;
  double height = 154;
  double weight = 70;
  int age;

  final _repository = Repository();

  final _mainPagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;
  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  final _selectedPageBehaviorSubject = PublishSubject<int>();
  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;
  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  final _errorBehaviorSubject = PublishSubject<String>();
  Stream<String> get errorStream => _errorBehaviorSubject.stream.asBroadcastStream();
  Sink<String> get errorSink => _errorBehaviorSubject.sink;

  final _selectedWeightBehaviorSubject = PublishSubject<double>();
  Stream<double> get selectedWeightStream => _selectedWeightBehaviorSubject.stream;
  Sink<double> get selectedWeightSink => _selectedWeightBehaviorSubject.sink;

  final _selectedHeightBehaviorSubject = PublishSubject<double>();
  Stream<double> get selectedHeightStream => _selectedHeightBehaviorSubject.stream;
  Sink<double> get selectedHeightSink => _selectedHeightBehaviorSubject.sink;

  final _selectedGenderBehaviorSubject = PublishSubject<int>();
  Stream<int> get selectedGenderStream => _selectedGenderBehaviorSubject.stream;
  Sink<int> get selectedGenderSink => _selectedGenderBehaviorSubject.sink;

  dispose() {
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _errorBehaviorSubject.close();
    _selectedWeightBehaviorSubject.close();
    _selectedHeightBehaviorSubject.close();
    _selectedGenderBehaviorSubject.close();
  }

  void createUser(Store<AppState> store) async {
    double bmi = weight / ((height * 0.01) * (height * 0.01));

    double fatPercentage = (1.20 * bmi) + (0.23 * age) - (10.8 * genderCode) - 5.4;
    String createdDate = DateFormat.yMMMd().format(DateTime.now());

    User user = User(
        name: name,
        gender: genderCode,
        age: age,
        height: height,
        weight: weight,
        bmi: bmi,
        fat_percentage: fatPercentage,
        created_date: createdDate,
        last_updated: createdDate);
    WeightHistory weightHistory = WeightHistory(
        weight: weight,
        date: DateFormat.yMMMd().format(DateTime.now()),
        time: DateFormat.jm().format(DateTime.now()),
        difference: '');

    await _repository.insertWeightHistory(weightHistory);
    await _repository.insertUser(user).then((val) {
      store.dispatch(UpdateUserAction(user: user));
      pageNavigationSink.add(NAVIGATE_ALL_DONE_TAB);
    });
  }
}
