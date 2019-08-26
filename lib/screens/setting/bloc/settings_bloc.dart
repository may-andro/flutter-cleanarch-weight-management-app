import 'dart:async';

import 'package:flutter_weighter/model/notification_item.dart';
import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SettingBloc {
  //String to store navigationId
  final _mainPagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;
  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  final _selectedPageBehaviorSubject = PublishSubject<int>();
  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;
  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  final _verticalPagerBehaviorSubject = PublishSubject<int>();
  Stream<int> get verticalPagerNavigationStream => _verticalPagerBehaviorSubject.stream;
  Sink<int> get verticalPagerNavigationSink => _verticalPagerBehaviorSubject.sink;
  
  //Stream and Sink to control duration
  final _themeSelectionBehaviorSubject = PublishSubject<ThemeItem>();
  Stream<ThemeItem> get themeSelectionStream => _themeSelectionBehaviorSubject.stream;
  Sink<ThemeItem> get themeSelectionSink => _themeSelectionBehaviorSubject.sink;

  final _focusedThemePagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get focusedThemePagerStream => _focusedThemePagerBehaviorSubject.stream;
  Sink<double> get focusedThemePagerSink => _focusedThemePagerBehaviorSubject.sink;

  final _focusedNotificationReminderBehaviorSubject = PublishSubject<NotificationItem>();
  Stream<NotificationItem> get focusedNotificationReminderStream => _focusedNotificationReminderBehaviorSubject.stream;
  Sink<NotificationItem> get focusedNotificationReminderSink => _focusedNotificationReminderBehaviorSubject.sink;

  dispose() {
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _verticalPagerBehaviorSubject.close();
    _themeSelectionBehaviorSubject.close();
    _focusedThemePagerBehaviorSubject.close();
    _focusedNotificationReminderBehaviorSubject.close();
  }

  Future resetApp() async{
  	final repo = Repository();

    await repo.deleteAllWeightHistory().then((val){
	    repo.deleteAllUser();
    });
  }
}
