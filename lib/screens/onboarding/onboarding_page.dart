import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/home/home_page.dart';
import 'package:flutter_weighter/screens/onboarding/tabs/age_tab.dart';
import 'package:flutter_weighter/screens/onboarding/tabs/all_done_tab.dart';
import 'package:flutter_weighter/screens/onboarding/tabs/gender_tab.dart';
import 'package:flutter_weighter/screens/onboarding/tabs/physical_tab.dart';
import 'package:flutter_weighter/screens/onboarding/tabs/nickname_tab.dart';
import 'package:flutter_weighter/screens/onboarding/tabs/welcome_tab.dart';
import 'package:flutter_weighter/screens/onboarding/widget/app_name_widget.dart';
import 'package:flutter_weighter/screens/onboarding/widget/create_account_button.dart';
import 'package:flutter_weighter/screens/onboarding/widget/reveal_animated_widget.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/fade_route_builder.dart';

import 'bloc/bloc_provider.dart';
import 'bloc/onboarding_bloc.dart';

const _submitAnimationTime = 500;
const _animationTime = 1000;

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _submitAnimationController;
  OnBoardingBloc _bloc;
  PageController _pageController;

  Future _navigateToPage(int page) async {
    _pageController.animateToPage(page, duration: Duration(milliseconds: _submitAnimationTime), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: _animationTime), vsync: this);
    _animationController.forward();
    _bloc = OnBoardingBloc();
    _bloc.pageNavigationStream.listen(_navigateToPage);
    _bloc.selectedGenderSink.add(GENDER_MALE_CODE);
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );
    _submitAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _submitAnimationTime),
    )..addStatusListener((status) {
        //add a listener
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacement(FadeRouteBuilder(page: HomePage()));
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _submitAnimationController.dispose();
    _bloc.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingBlocProvider(
      bloc: _bloc,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildBody(),
              AppNameWidget(),
              CreateAccountButton(),
              RevealAnimatedWidget(
                animation: _submitAnimationController,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBody() => AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return SafeArea(child: _createPager());
      });

  _createPager() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          _bloc.mainPagerSink.add(_pageController.page);
          if (_pageController.page == 0) _animationController.forward();
        }
        return true;
      },
      child: PageView(
        onPageChanged: (pos) {
          _bloc.pageNavigationSink.add(pos);
          _bloc.currentPage = pos;
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        children: <Widget>[
          WelcomeTab(
              animationController: _animationController,
              onPressed: () {
                _animationController.reset();
                _bloc.pageNavigationSink.add(NAVIGATE_TO_NICK_NAME_TAB);
              }),
          NickNameTab(),
          GenderTab(),
          AgeTab(),
          PhysicalTab(),
          AllDoneTab(
              animationController: _submitAnimationController,
              onFinishClick: () {
                _submitAnimationController.forward();
              }),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    switch (_bloc.currentPage) {
      case NAVIGATE_TO_WELCOME_TAB:
        return true;
      case NAVIGATE_TO_NICK_NAME_TAB:
        _bloc.pageNavigationSink.add(NAVIGATE_TO_WELCOME_TAB);
        return false;
      case NAVIGATE_TO_GENDER_TAB:
        _bloc.pageNavigationSink.add(NAVIGATE_TO_NICK_NAME_TAB);
        return false;
      case NAVIGATE_TO_AGE_TAB:
        _bloc.pageNavigationSink.add(NAVIGATE_TO_GENDER_TAB);
        return false;
      case NAVIGATE_TO_PHYSICAL_TAB:
        _bloc.pageNavigationSink.add(NAVIGATE_TO_AGE_TAB);
        return false;
      case NAVIGATE_ALL_DONE_TAB:
        _submitAnimationController.forward();
        return false;
      default:
        _bloc.pageNavigationSink.add(NAVIGATE_TO_WELCOME_TAB);
        return false;
    }
  }
}
