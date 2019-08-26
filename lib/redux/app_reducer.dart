import 'dart:ui';

import 'package:flutter_weighter/model/notification_item.dart';
import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:redux/redux.dart';

import 'app_actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    themeData: changeThemeReducer(state.themeData, action),
    user: changeUserReducer(state.user, action),
    locale: changeLocaleReducer(state.locale, action),
    notificationItem: changeNotificationReminderReducer(state.notificationItem, action),
  );
}

final changeThemeReducer = combineReducers<ThemeItem>([
  TypedReducer<ThemeItem, ChangeThemeAction>(_changeThemeReducer),
]);

ThemeItem _changeThemeReducer(ThemeItem id, ChangeThemeAction action) {
  return action.themeId;
}

final changeUserReducer = combineReducers<User>([
  TypedReducer<User, UpdateUserAction>(_changeUserReducer),
]);

User _changeUserReducer(User user, UpdateUserAction action) {
  return action.user;
}

final changeLocaleReducer = combineReducers<Locale>([
  TypedReducer<Locale, UpdateLocaleAction>(_changeLocaleReducer),
]);

Locale _changeLocaleReducer(Locale locale, UpdateLocaleAction action) {
  return action.locale;
}

final changeNotificationReminderReducer = combineReducers<NotificationItem>([
  TypedReducer<NotificationItem, UpdateNotificationReminderAction>(_changeNotificationReminderReducer),
]);

NotificationItem _changeNotificationReminderReducer(
    NotificationItem notificationItem, UpdateNotificationReminderAction action) {
  return action.notificationItem;
}
