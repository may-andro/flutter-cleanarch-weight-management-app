import 'dart:ui';

import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/utility/constants.dart';

class AppState {
	final ThemeItem themeData;
	final User user;
	final Locale locale;

	AppState({
		this.themeData,
		this.user,
		this.locale
	});

	factory AppState.initial() {
		return AppState(
			themeData: themeList[0],
			user: null,
			locale: Locale('en', '')
		);
	}

	AppState copyWith({
		int themeDataId,
		User user,
		Locale local
	}) {
		return AppState(
			themeData: themeDataId ?? this.themeData,
			user: user ?? this.themeData,
			locale: local ?? this.locale,
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
}