import 'dart:ui';

import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/model/user.dart';

class ChangeThemeAction {
	ChangeThemeAction({this.themeId});
	ThemeItem themeId;
}

class UpdateUserAction {
	UpdateUserAction({this.user});
	User user;
}

class UpdateLocaleAction {
	UpdateLocaleAction({this.locale});
	Locale locale;
}