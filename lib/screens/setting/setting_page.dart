import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/setting/tab/language_tab.dart';
import 'package:flutter_weighter/screens/setting/tab/settings_tab.dart';
import 'package:flutter_weighter/screens/setting/tab/theme_tab.dart';
import 'package:flutter_weighter/utility/constants.dart';

import 'bloc/bloc_provider.dart';
import 'bloc/settings_bloc.dart';

class SettingPage extends StatefulWidget {
	@override
	_SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin {
	AnimationController animationController;
	SettingBloc bloc;
	PageController pageController;
	int currentPage = NAVIGATE_TO_SETTINGS_TAB;

	@override
	void initState() {
		super.initState();
		animationController = new AnimationController(
			duration: const Duration(milliseconds: 300),
			value: 1.0,
			vsync: this,
		);
		pageController = PageController(
			initialPage: currentPage,
			viewportFraction: 1.0,
		);
		bloc = SettingBloc();
		bloc.pageNavigationStream.listen(_navigateToPage);
	}

	Future _navigateToPage(int page) async {
		pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.ease);
	}

	@override
	void dispose() {
		animationController.dispose();
		bloc.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SettingsBlocProvider(
			bloc: bloc,
			child: Scaffold(
				body: _createPager(),
			),
		);
	}

	_createPager() {
		return NotificationListener<ScrollNotification>(
			onNotification: (ScrollNotification notification) {
				if (notification is ScrollUpdateNotification) {
					bloc.mainPagerSink.add(pageController.page);
					if (pageController.page == 0) animationController.forward();
				}
				return true;
			},
			child: PageView(
				onPageChanged: (pos) {
					bloc.pageNavigationSink.add(pos);
					currentPage = pos;
				},
				physics: NeverScrollableScrollPhysics(),
				scrollDirection: Axis.horizontal,
				controller: pageController,
				children: <Widget>[
					ThemeTabs(),
					SettingsTabs(),
					LanguageTabs()
				],
			),
		);
	}
}
