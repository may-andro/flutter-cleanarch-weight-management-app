import 'package:flutter_weighter/model/ideal_bmi.dart';
import 'package:flutter_weighter/model/ideal_fat.dart';
import 'package:flutter_weighter/model/notification_item.dart';
import 'package:flutter_weighter/model/theme_item.dart';

import 'color_utility.dart';

const NAVIGATION_ONBOARDING = '/onboarding';
const NAVIGATION_DASHBOARD = '/dashboard';

const USER_LOCALE = 'user_locale';

const NAVIGATE_TO_WELCOME_TAB = 0;
const NAVIGATE_TO_NICK_NAME_TAB = 1;
const NAVIGATE_TO_GENDER_TAB = 2;
const NAVIGATE_TO_AGE_TAB = 3;
const NAVIGATE_TO_PHYSICAL_TAB = 4;
const NAVIGATE_ALL_DONE_TAB = 5;

const NAVIGATE_TO_SETTINGS_THEME_TAB = 0;
const NAVIGATE_TO_SETTINGS_TAB = 1;
const NAVIGATE_TO_SETTINGS_LANGUAGE_TAB = 2;
const NAVIGATE_TO_SETTINGS_ABOUT_TAB = 1;
const NAVIGATE_TO_SETTINGS_LIST_TAB = 0;

const GENDER_FEMALE_CODE = 0;
const GENDER_MALE_CODE = 1;


const SCALE_FRACTION = 0.7;
const FULL_SCALE = 1.0;
const MIN_HEIGHT = 100;
const MAX_HEIGHT = 200;
const MIN_WEIGHT = 30;
const MAX_WEIGHT = 130;

const SELECTED_THEME = 'SELECTED_THEME';
const SELECTED_THEME_RED = 0;
const SELECTED_THEME_BLUE = 1;
const SELECTED_THEME_GREEN = 2;
const SELECTED_THEME_YELLOW = 3;
const SELECTED_THEME_DARK = 4;

const SELECTED_NOTIFICATION = 'SELECTED_NOTIFICATION';
const SELECTED_NOTIFICATION_DAILY = 0;
const SELECTED_NOTIFICATION_WEEKLY = 1;
const SELECTED_NOTIFICATION_NONE = 2;

List<IdealBMI> idealBMIList = [
	IdealBMI(
			'highly_severe_underweight',
			0,
			14.9,
			COLOR_DANGER
	),
	IdealBMI(
			'severe_underweight',
			15,
			15.9,
			COLOR_DANGER
	),
	IdealBMI(
			'underweight',
			16,
			18.4,
			COLOR_WARNING
	),
	IdealBMI(
			'normal_healthy_weight',
			18.5,
			24.9,
			COLOR_NORMAL
	),
	IdealBMI(
			'overweight',
			25,
			29.9,
			COLOR_WARNING
	),
	IdealBMI(
			'obese_class_1',
			30,
			34.9,
			COLOR_DANGER
	),
	IdealBMI(
			'obese_class_2',
			35,
			39.9,
			COLOR_DANGER
	),
	IdealBMI(
			'obese_class_3',
			40,
			1000,
			COLOR_DANGER
	),

];

List<IdealFat> idealFatList = [
	IdealFat(
			'essential_level',
			2,
			5,
			10,
			13,
			COLOR_WARNING
	),
	IdealFat(
			'athletes_level',
			6,
			13,
			14,
			20,
			COLOR_GOOD
	),
	IdealFat(
			'fitness_level',
			14,
			17,
			21,
			24,
			COLOR_BETTER
	),
	IdealFat(
			'average_level',
			18,
			24,
			24,
			31,
			COLOR_NORMAL
	),
	IdealFat(
			'obese_level',
			25,
			1000,
			32,
			1000,
			COLOR_DANGER
	)

];

List<ThemeItem> themeList = [
	ThemeItem(
			SELECTED_THEME_RED,
			'Theme Red',
			THEME_COLOR_RED
	),
	ThemeItem(
			SELECTED_THEME_BLUE,
			'Theme Blue',
			THEME_COLOR_BLUE
	),
	ThemeItem(
			SELECTED_THEME_GREEN,
			'Theme Green',
			THEME_COLOR_GREEN
	),
	ThemeItem(
			SELECTED_THEME_YELLOW,
			'Theme Yellow',
			THEME_COLOR_YELLOW
	),
	ThemeItem(
			SELECTED_THEME_DARK,
			'Theme Dark',
			THEME_COLOR_DARK
	),
];

List<NotificationItem> notificationItemList = [
	NotificationItem(
			SELECTED_NOTIFICATION_DAILY,
			'daily',
			THEME_COLOR_RED
	),
	NotificationItem(
			SELECTED_NOTIFICATION_WEEKLY,
			'weekly',
			THEME_COLOR_BLUE
	),
	NotificationItem(
			SELECTED_NOTIFICATION_NONE,
			'turn_off',
			THEME_COLOR_BLUE
	),
];
