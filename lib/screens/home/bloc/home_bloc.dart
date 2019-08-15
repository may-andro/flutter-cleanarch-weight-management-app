import 'dart:async';

import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/text_utility.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  User currentUser;
  double editedHeight = 0;
  int editedAge = 0;

  final _repository = Repository();
  final Store<AppState> store;

  final _mainPagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;
  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  final _selectedPageBehaviorSubject = PublishSubject<int>();
  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;
  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  final _updateUserBehaviorSubject = PublishSubject<User>();
  Stream<User> get updateUserStream => _updateUserBehaviorSubject.stream;
  Sink<User> get updateUserSink => _updateUserBehaviorSubject.sink;

  //Stream and Sink to control duration
  final _ageSelectionBehaviorSubject = PublishSubject<int>();
  Stream<int> get ageSelectionStream => _ageSelectionBehaviorSubject.stream;
  Sink<int> get ageSelectionSink => _ageSelectionBehaviorSubject.sink;

  //Stream and Sink to control duration
  final _heightSelectionBehaviorSubject = PublishSubject<int>();
  Stream<int> get heightSelectionStream => _heightSelectionBehaviorSubject.stream;
  Sink<int> get heightSelectionSink => _heightSelectionBehaviorSubject.sink;

  final _focusedHeightPagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get focusedHeightPagerStream => _focusedHeightPagerBehaviorSubject.stream;
  Sink<double> get focusedHeightPagerSink => _focusedHeightPagerBehaviorSubject.sink;

  HomeBloc(this.store) {
    updateUserStream.listen(updateUser);
    heightSelectionStream.listen(updateEditedHeight);
  }

  dispose() {
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _updateUserBehaviorSubject.close();
    _ageSelectionBehaviorSubject.close();
    _heightSelectionBehaviorSubject.close();
    _focusedHeightPagerBehaviorSubject.close();
  }

  Future updateUser(User event) async {
    await _repository.updateUser(event).then((val) {
      currentUser = event;
      store.dispatch(UpdateUserAction(user: event));
    });
  }

  String getGenderText(int code, String labelMen, String labelWomen) {
    return code == GENDER_MALE_CODE ? labelMen : labelWomen;
  }

  void updateEditedHeight(int event) {
    editedHeight = event.toDouble();
  }

  String calculateFatValue(int genderCode, double height) {
	  double idealWeight;
	  double heightInInches = height / 2.54;
	  if (genderCode == GENDER_MALE_CODE) {
		  idealWeight = 52 + (1.9 * (heightInInches - 60));
	  } else {
		  idealWeight = 49 + (1.7 * (heightInInches - 60));
	  }

	  return format(idealWeight.ceil().toDouble());
  }

  Future saveUpdatedProfile() async {
	  if ((editedHeight != 0 && editedHeight != currentUser.height)) {
		  currentUser.height = editedHeight;
	  }

	  if ((editedAge != 0 && editedAge != currentUser.age)) {
		  currentUser.age = editedAge;
	  }

	  currentUser.bmi = currentUser.weight / ((currentUser.height * 0.01) * (currentUser.height * 0.01));
	  currentUser.fat_percentage = (1.20 * currentUser.bmi) + (0.23 * currentUser.age) - (10.8 * currentUser.gender) - 5.4;
	  currentUser.last_updated = DateFormat.yMMMd().format(DateTime.now());

	  updateUser(currentUser).then((value) {
		  pageNavigationSink.add(0);
	  });
  }
}
