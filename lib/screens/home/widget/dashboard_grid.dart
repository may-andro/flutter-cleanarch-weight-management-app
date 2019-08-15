import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/add_weight/add_weight.dart';
import 'package:flutter_weighter/screens/body_chart/body_chart_page.dart';
import 'package:flutter_weighter/screens/fat_calculator/fat_calculator_page.dart';
import 'package:flutter_weighter/screens/home/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/home/bloc/home_bloc.dart';
import 'package:flutter_weighter/screens/weight_history/weight_trend_page.dart';
import 'package:flutter_weighter/utility/fade_route_builder.dart';
import 'package:flutter_weighter/utility/text_utility.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:redux/redux.dart';

class DashboardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  	final _bloc = HomeBlocProvider.of(context);

    final gridItemList = [
	    GridItem([
		    Color(0xfff6356f),
		    Color(0xffff5f50),
	    ], Icons.add_circle, AppTranslations.of(context).text("update_weight"), AddWeight()),
	    GridItem([
		    Color(0xfff58573),
		    Color(0xff5f79f4),
	    ], Icons.trending_down, AppTranslations.of(context).text("history"), WeightTrendPage()),
	    GridItem([
		    Color(0xff52a7ea),
		    Color(0xff712e98),
	    ], Icons.insert_chart, AppTranslations.of(context).text("body_chart"), BodyChartPage()),
	    GridItem([
		    Color(0xff46a3b7),
		    Color(0xffa6f1de),
	    ], Icons.dashboard, AppTranslations.of(context).text("fat_calculator"), FatCalculatorPage()),
    ];

    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: StoreConnector<AppState, User>(
	        converter: (Store<AppState> store) => store.state.user,
	        builder: (BuildContext context, User user) {
		        return Center(
			        child: GridView.builder(
				        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
					        crossAxisCount: 2,
					        mainAxisSpacing: MediaQuery.of(context).size.shortestSide * 0.05,
					        crossAxisSpacing: MediaQuery.of(context).size.shortestSide * 0.05,
					        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height * 0.5),
				        ),
				        itemCount: gridItemList.length,
				        padding: const EdgeInsets.all(4.0),
				        shrinkWrap: true,
				        itemBuilder: (context, index) {
					        return _GridItemWidget(gridItemList[index], _getLatestDataForSubtitle(index, user, _bloc, context));
				        },
			        ),
		        );
          },
        ));
  }

  String _getLatestDataForSubtitle(int index, User user, HomeBloc bloc, BuildContext context) {
    switch (index) {
      case 0:
        return AppTranslations.of(context).text("add_new_weight");
      case 1:
        return '${AppTranslations.of(context).text("weight")}: ${user.weight}' ;
      case 2:
        return '${AppTranslations.of(context).text("ideal_weight")} ${bloc.calculateFatValue(user.gender, user.height)} ${AppTranslations.of(context).text("kg")}';
      case 3:
        return '${AppTranslations.of(context).text("bpf_short")}: ${format(user.fat_percentage)} %';
      default:
        return '';
    }
  }
}

class _GridItemWidget extends StatelessWidget {
  final GridItem gridItem;
  final String gridSubTitle;

  _GridItemWidget(this.gridItem, this.gridSubTitle);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(FadeRouteBuilder(page: gridItem.widgetScreen)),
      child: GridTile(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.025),
          child: new Material(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(
                      flex: 5,
                    ),
                    Hero(
                      tag: gridItem.title,
                      child: Text(
                        gridItem.title,
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
                      ),
                    ),
                    Text(
                      gridSubTitle,
                      style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.shortestSide * 0.03),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                    Icon(
                      gridItem.icon,
                      size: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white,
                    ),
                    Spacer(
                      flex: 5,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class GridItem {
  final List<Color> colorList;
  final IconData icon;
  final String title;
  final Widget widgetScreen;

  GridItem(this.colorList, this.icon, this.title, this.widgetScreen);
}
