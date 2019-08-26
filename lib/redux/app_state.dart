import 'dart:ui';

import 'package:flutter_weighter/model/notification_item.dart';
import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
	final ThemeItem themeData;
	final User user;
	final Locale locale;
	final NotificationItem notificationItem;

	AppState({
		this.themeData,
		this.user,
		this.locale,
		this.notificationItem,
	});

	factory AppState.initial(SharedPreferences prefs){
		int themeId = prefs.getInt(SELECTED_THEME) ?? 0;
		String userLocale = prefs.getString(USER_LOCALE) ?? 'en';
		int notificationId = prefs.getInt(SELECTED_NOTIFICATION) ?? SELECTED_NOTIFICATION_NONE;
		return AppState(
			themeData: themeList.firstWhere((item) => item.id == themeId, orElse: () => themeList[0]),
			user: null,
			locale: Locale(userLocale, '',),
			notificationItem: notificationItemList.firstWhere((item) => item.id == notificationId, orElse: () => notificationItemList[3]),
		);
	}

	AppState copyWith({
		int themeDataId,
		User user,
		Locale local,
		NotificationItem notificationItem,
	}) {
		return AppState(
			themeData: themeDataId ?? this.themeData,
			user: user ?? this.themeData,
			locale: local ?? this.locale,
			notificationItem: notificationItem ?? this.notificationItem,
		);
	}

	AppState setThemeDataId({int id}) {
		return copyWith(themeDataId: id ?? this.themeData);
	}

	AppState setUser({User user}) {
		return copyWith(user: user ?? this.user);
	}

	AppState setLocal({Locale local}) {
		return copyWith(local: local ?? this.locale);
	}

	AppState setNotificationItem({NotificationItem notificationItem}) {
		return copyWith(notificationItem: notificationItem ?? this.notificationItem);
	}
}