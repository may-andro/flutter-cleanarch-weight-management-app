import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/home/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/home/tabs/dashboard_tab.dart';
import 'package:flutter_weighter/screens/home/tabs/profile_tab.dart';
import 'package:flutter_weighter/screens/home/widget/bmi_bottom_sheet.dart';
import 'package:flutter_weighter/screens/home/widget/dashboard_grid.dart';
import 'package:flutter_weighter/screens/home/widget/user_profile_row.dart';
import 'package:flutter_weighter/screens/setting/setting_page.dart';
import 'package:flutter_weighter/utility/fade_route_builder.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc;
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = StoreProvider.of<AppState>(context);
    _bloc = HomeBloc(store);
    _bloc.currentUser = store.state.user;
    _bloc.pageNavigationStream.listen(_navigateToPage);
  }

  Future _navigateToPage(int page) async {
    _pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return HomeBlocProvider(
      bloc: _bloc,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            children: <Widget>[_buildPageView(), BMIBottomSheet(), _BackButton(), _SaveButton(), _SettingButton()],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  _buildPageView() => Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          children: <Widget>[
            UserProfileRow(),
            Expanded(
              child: StreamBuilder<double>(
                  stream: _bloc.mainPagerStream,
                  builder: (context, snapshot) {
                    double scroll = snapshot.hasData ? snapshot.data : 0;
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15 * (1 - scroll)),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollUpdateNotification) {
                            _bloc.mainPagerSink.add(_pageController.page);
                          }

                          return true;
                        },
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[DashboardGrid(), ProfileTab()],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = HomeBlocProvider.of(context);
    return Positioned(
      top: 32,
      left: MediaQuery.of(context).size.shortestSide * 0.03,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 0;
            return Transform.translate(
              offset: Offset(-MediaQuery.of(context).size.width * 0.15 * (1 - scroll), 0),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _bloc.pageNavigationSink.add(0);
                  }),
            );
          }),
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = HomeBlocProvider.of(context);
    final snackBar = SnackBar(
      content: Text(
        AppTranslations.of(context).text("no_update"),
      ),
    );

    return Positioned(
      top: 32,
      right: MediaQuery.of(context).size.shortestSide * 0.03,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 0;
            return Transform.translate(
              offset: Offset(MediaQuery.of(context).size.width * 0.15 * (1 - scroll), 0),
              child: IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if ((_bloc.editedHeight != 0 && _bloc.editedHeight != _bloc.currentUser.height) ||
                        (_bloc.editedAge != 0 && _bloc.currentUser.age != _bloc.editedAge)) {
                      _bloc.saveUpdatedProfile();
                    } else {
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  }),
            );
          }),
    );
  }
}

class _SettingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = HomeBlocProvider.of(context);

    return Positioned(
      top: 32,
      right: MediaQuery.of(context).size.shortestSide * 0.15,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 0;
            return Opacity(
              opacity: scroll,
              child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(FadeRouteBuilder(page: SettingPage()));
                  }),
            );
          }),
    );
  }
}
