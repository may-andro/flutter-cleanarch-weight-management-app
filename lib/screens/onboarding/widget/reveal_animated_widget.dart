import 'package:flutter/material.dart';
import 'dart:math' as math;

class RevealAnimatedWidget extends AnimatedWidget {
  RevealAnimatedWidget({Key key, Listenable animation})
      : super(key: key, listenable: animation);

  Animation<int> get positionAnimation => IntTween(
    begin: 0,
    end: 50,
  ).animate(
    CurvedAnimation(
      parent: super.listenable,
      curve: Interval(0.15, 0.3),
    ),
  );

  Animation<double> get sizeAnimation => Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: super.listenable,
      curve: Interval(0.3, 1),
    ),
  );


  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double height = math.min(52 + deviceHeight * sizeAnimation.value, deviceHeight);
    double width = math.min(52 + deviceWidth * sizeAnimation.value, deviceWidth);

    Decoration decoration = BoxDecoration(
      shape: width < 0.5 * deviceWidth ? BoxShape.circle : BoxShape.rectangle,
      color: Theme.of(context).primaryColor,
    );

    Widget dot = Container(
      decoration: decoration,
      width: width ,
      height: height ,
    );

    return IgnorePointer(
      child: Opacity(
        opacity: (super.listenable as Animation).value > 0.15 ? 1.0 : 0.0,
        child: Scaffold(
          primary: false,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Spacer(flex: 104 - positionAnimation.value),
                dot,
                Spacer(flex: 4 + positionAnimation.value),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
