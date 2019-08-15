import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/home/bloc/home_bloc.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';

import 'dart:math';

import 'package:flutter_weighter/utility/translation/app_translations.dart';

class HeightPager extends StatelessWidget {
  final PageController pageController;
  HomeBloc bloc;
  int currentHeight;

  HeightPager({this.bloc, this.currentHeight})
      : pageController = PageController(initialPage: currentHeight - MIN_HEIGHT, viewportFraction: 0.5);

  var heightList = new List<int>.generate(MIN_HEIGHT, (i) => MIN_HEIGHT + i);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: _pager(context)),
        _seeMoreLabel(context),
      ],
    );
  }

  Widget _seeMoreLabel(BuildContext context) {
    return StreamBuilder<int>(
        stream: bloc.heightSelectionStream,
        builder: (context, snapshot) {
          int height = snapshot.hasData ? snapshot.data : currentHeight;
          return Text(
            'Height: $height ${AppTranslations.of(context).text("cm")}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w300,
                fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
          );
        });
  }

  Widget _pager(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          bloc.focusedHeightPagerSink.add(pageController.page);
        }
        return;
      },
      child: StreamBuilder<double>(
          stream: bloc.focusedHeightPagerStream,
          builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
            double pageOffset = snapshot.hasData ? snapshot.data : currentHeight.toDouble() - MIN_HEIGHT;
            return PageView.builder(
              onPageChanged: (pos) {
                bloc.heightSelectionSink.add(heightList[pos]);
              },
              controller: pageController,
              itemCount: heightList.length,
              itemBuilder: (context, index) {
                final scale = max(SCALE_FRACTION, (FULL_SCALE - (index - pageOffset).abs()) + 0.5);
                return circleImage(heightList.elementAt(index).toString(), scale, context);
              },
            );
          }),
    );
  }

  Widget circleImage(String image, double scale, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: MediaQuery.of(context).size.shortestSide * 0.15 * scale,
        width: MediaQuery.of(context).size.shortestSide * 0.15 * scale,
        child: Opacity(
          opacity: scale > 1 ? 1 : scale,
          child: Card(
            color: Color(getColorHexFromStr(COLOR_GOOD)),
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(side: BorderSide(color: Colors.grey.shade200, width: 0)),
            child: Center(
              child: Text(
                image,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: MediaQuery.of(context).size.shortestSide * 0.03 * scale),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
