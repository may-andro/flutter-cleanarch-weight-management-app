import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weighter/utility/constants.dart';

class WeightCard extends StatelessWidget {
  final int weight;
  final ValueChanged<int> onChanged;

  const WeightCard({Key key, this.weight = 70, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return drawSlider();
  }

  Widget drawSlider() {
    return WeightBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSlider(
                  minValue: MIN_WEIGHT,
                  maxValue: MAX_WEIGHT,
                  value: weight,
                  onChanged: (val) => onChanged(val),
                  width: constraints.maxWidth,
                );
        },
      ),
    );
  }
}

class WeightBackground extends StatelessWidget {
  final Widget child;

  const WeightBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: child,
        ),
        SvgPicture.asset(
          "assets/images/weight_arrow.svg",
          height: 10,
          width: 10,
        ),
      ],
    );
  }
}

class WeightSlider extends StatelessWidget {
  WeightSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.value,
    @required this.onChanged,
    @required this.width,
  })  : scrollController = new ScrollController(
          initialScrollOffset: (value - minValue) * width / 5,
        ),
        super(key: key);

  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int> onChanged;
  final double width;
  final ScrollController scrollController;

  double get itemExtent => width / 5;

  int indexToValue(int index) => minValue + (index - 2);

  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 5;
    return NotificationListener(
      onNotification: onNotification,
      child: new ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          int itemValue = indexToValue(index);
          bool isExtra = index < 2 || index > itemCount - 3;

          return isExtra
              ? new Container() //empty first and last element
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => animateTo(itemValue, durationMillis: 50),
                  child: FittedBox(
                    child: Text(
                      itemValue.toString(),
                      style: getTextStyle(context, itemValue),
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                );
        },
      ),
    );
  }

  TextStyle getDefaultTextStyle(BuildContext context) {
    return new TextStyle(
      color: Color.fromRGBO(196, 197, 203, 1.0),
      fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
    );
  }

  TextStyle getHighlightTextStyle(BuildContext context) {
    return new TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: MediaQuery.of(context).size.shortestSide * 0.1,
    );
  }

  TextStyle getTextStyle(BuildContext context, int itemValue) {
    return itemValue == value ? getHighlightTextStyle(context) : getDefaultTextStyle(context);
  }

  bool userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  int offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = offsetToMiddleIndex(offset);
    int middleValue = indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = offsetToMiddleValue(notification.metrics.pixels);

      if (userStoppedScrolling(notification)) {
        animateTo(middleValue);
      }

      if (middleValue != value) {
        onChanged(middleValue); //update selection
      }
    }
    return true;
  }
}
