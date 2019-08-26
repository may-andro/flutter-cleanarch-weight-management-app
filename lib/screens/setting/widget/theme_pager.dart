import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/setting/bloc/settings_bloc.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';

import 'dart:math';

import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePager extends StatelessWidget {
  final PageController pageController;
  final ThemeItem currentTheme;

  ThemePager({this.currentTheme})
      : pageController = PageController(initialPage: currentTheme.id, viewportFraction: 0.5);

  @override
  Widget build(BuildContext context) {
    final bloc = SettingsBlocProvider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: _pager(context, bloc)),
        selectedThemeText(context, bloc),
      ],
    );
  }

  Widget selectedThemeText(BuildContext context, SettingBloc bloc) {
    return StreamBuilder<ThemeItem>(
        stream: bloc.themeSelectionStream,
        builder: (context, snapshot) {
          ThemeItem theme = snapshot.hasData ? snapshot.data : currentTheme;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 48.0),
            child: Container(
              height: MediaQuery.of(context).size.shortestSide * 0.125,
              width: double.infinity,
              child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.shortestSide * 0.15)),
                  padding: EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Text(AppTranslations.of(context).text("update"),
                      style:
                          TextStyle(color: Colors.black87, fontSize: MediaQuery.of(context).size.shortestSide * 0.04)),
                  onPressed: () {
                    setThemeInPreference(theme.id).then((val) {
                      StoreProvider.of<AppState>(context).dispatch(ChangeThemeAction(themeId: theme));
                      bloc.pageNavigationSink.add(NAVIGATE_TO_SETTINGS_TAB);
                    });
                  }),
            ),
          );
        });
  }

  Future setThemeInPreference(int themeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SELECTED_THEME, themeId);
  }

  Widget _pager(BuildContext context, SettingBloc bloc) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          bloc.focusedThemePagerSink.add(pageController.page);
        }
        return;
      },
      child: StreamBuilder<double>(
          stream: bloc.focusedThemePagerStream,
          builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
            double pageOffset = snapshot.hasData ? snapshot.data : currentTheme.id.toDouble();
            return PageView.builder(
              onPageChanged: (pos) {
                bloc.themeSelectionSink.add(themeList[pos]);
              },
              controller: pageController,
              itemCount: themeList.length,
              itemBuilder: (context, index) {
                final scale = max(SCALE_FRACTION, (FULL_SCALE - (index - pageOffset).abs()) + 0.5);
                return circleImage(themeList.elementAt(index), scale, context);
              },
            );
          }),
    );
  }

  Widget circleImage(ThemeItem themeItem, double scale, BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: MediaQuery.of(context).size.shortestSide * 0.5 * scale,
        width: MediaQuery.of(context).size.shortestSide * 0.5 * scale,
        child: Opacity(
          opacity: scale > 1 ? 1 : scale,
          child: Card(
            color: Color(getColorHexFromStr(themeItem.color)),
            elevation: 24,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(side: BorderSide(color: Colors.grey.shade200, width: 4)),
          ),
        ),
      ),
    );
  }
}
