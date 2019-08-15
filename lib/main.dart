import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/redux/app_store.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:flutter_weighter/screens/home/home_page.dart';
import 'package:flutter_weighter/screens/onboarding/onboarding_page.dart';
import 'package:flutter_weighter/screens/splash/splash_page.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations_delegate.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/theme_item.dart';

void main() => run();

Future run() async {
  //runApp(SplashPage());

  var store = await createStore();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    Repository().getUserCount().then((count) {
      print('run count $count');
      if (count > 0) {
        Repository().getCurrentUser().then((user) {
          store.dispatch(UpdateUserAction(user: user));
          runApp(MyApp(HomePage(), store));
        });
      } else {
        runApp(MyApp(OnBoardingPage(), store));
      }
    });
  });
}

class MyApp extends StatelessWidget {
  final Widget home;
  final Store<AppState> store;
  AppTranslationsDelegate _newLocaleDelegate;

  MyApp(this.home, this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, appState) {
            _newLocaleDelegate = AppTranslationsDelegate(newLocale: store.state.locale);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Weighter',
              theme: ThemeProvider(store.state.themeData)._getAppTheme(),
              home: home,
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => HomePage(),
                '/onboarding': (BuildContext context) => OnBoardingPage(),
              },
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                Locale locale;
                getLocaleFromPreference().then((savedLocale) {
                  if (savedLocale.isEmpty) {
                    setLocaleInPreference(deviceLocale).then((val) {
                      locale = deviceLocale;
                      store.dispatch(UpdateLocaleAction(locale: locale));
                    });
                  } else {
                    locale = Locale(savedLocale, '');
                    store.dispatch(UpdateLocaleAction(locale: locale));
                  }
                });
                return;
              },
              localizationsDelegates: [
                _newLocaleDelegate,
                //provides localised strings
                GlobalMaterialLocalizations.delegate,
                //provides RTL support
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale("en", ""),
                const Locale("es", ""),
              ],
            );
          },
        ));
  }

  Future<String> getLocaleFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userLocale = prefs.getString(USER_LOCALE) ?? "";
    return userLocale;
  }

  Future setLocaleInPreference(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_LOCALE, locale.languageCode);
  }
}

class ThemeProvider {
  final ThemeItem themeItem;

  ThemeProvider(this.themeItem);

  ThemeData _getAppTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: Color(getColorHexFromStr(themeItem.color)),
      accentColor: Color(getColorHexFromStr(themeItem.color)),
      scaffoldBackgroundColor: Color(getColorHexFromStr('#FAFAFA')),
      backgroundColor: Color(getColorHexFromStr('#FAFAFA')),
	    brightness: Brightness.dark,
    );
  }
}
