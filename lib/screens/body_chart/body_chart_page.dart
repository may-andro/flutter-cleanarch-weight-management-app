import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/body_chart/tabs/bfp_tab.dart';
import 'package:flutter_weighter/screens/body_chart/tabs/bmi_tab.dart';
import 'package:flutter_weighter/screens/body_chart/tabs/weight_tab.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';
import 'package:flutter/rendering.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/body_chart_bloc.dart';

final TABS_LENGTH = 3;

class BodyChartPage extends StatefulWidget {
  @override
  _BodyChartPageState createState() => _BodyChartPageState();
}

class _BodyChartPageState extends State<BodyChartPage> with TickerProviderStateMixin {
  BodyChartBloc _bloc;
  AnimationController _animationController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: TABS_LENGTH);
    _animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _bloc = BodyChartBloc();
    _bloc.getUserSink.add(true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bloc.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyChartBlocProvider(
        bloc: _bloc,
        child: Scaffold(
          body: buildContent(),
        ));
  }

  buildContent() {
    List<Tab> tabs = <Tab>[
      Tab(text: AppTranslations.of(context).text("weight")),
      Tab(text: AppTranslations.of(context).text("bmi_short")),
      Tab(text: AppTranslations.of(context).text("bpf_short"))
    ];

    return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return BaseSliverHeader(
            title: AppTranslations.of(context).text("body_chart_title"),
            bodyWidget: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: Colors.blueAccent,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: tabs,
                    controller: _tabController,
                  ),
                ),
              ),
              body: TabBarView(controller: _tabController, children: [
                WeightTab(),
                BMITab(),
                BFPTab(),
              ]),
            ),
          );
        });
  }
}
