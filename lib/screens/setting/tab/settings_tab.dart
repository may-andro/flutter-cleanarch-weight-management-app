import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/setting/tab/setting_list_tab.dart';
import 'package:flutter_weighter/utility/constants.dart';

import 'about_tab.dart';

class SettingsTabs extends StatefulWidget {
  @override
  _SettingsTabsState createState() => _SettingsTabsState();
}

class _SettingsTabsState extends State<SettingsTabs> {
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: NAVIGATE_TO_SETTINGS_LIST_TAB,
      viewportFraction: 1.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SettingsBlocProvider.of(context).verticalPagerNavigationStream.listen(_navigateToPage);
  }

  Future _navigateToPage(int page) async {
    pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: pageController,
      children: <Widget>[SettingListTab(), AboutTab()],
    );
  }
}
