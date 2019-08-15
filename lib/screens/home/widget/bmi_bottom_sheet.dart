import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/home/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/text_utility.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:redux/redux.dart';

const double minHeight = 120;
const double iconStartSize = 44; //<-- add edge values
const double iconEndSize = 120; //<-- add edge values
const double iconStartMarginTop = 36; //<-- add edge values
const double iconEndMarginTop = 80; //<-- add edge values
const double iconsVerticalSpacing = 24; //<-- add edge values
const double iconsHorizontalSpacing = 16; //<-- add edge values

class BMIBottomSheet extends StatefulWidget {
  @override
  _BMIBottomSheetState createState() => _BMIBottomSheetState();
}

class _BMIBottomSheetState extends State<BMIBottomSheet> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height;

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value); //<-- lerp any value based on the controller

  //to control open close icon
  double get openCloseIconMargin => lerp(0, MediaQuery.of(context).padding.top);

  double get openCloseIconSize => lerp(30, 40);

  // to control header font and margin
  double get headerTopMargin =>
      lerp(MediaQuery.of(context).size.height * 0.05, MediaQuery.of(context).size.height * 0.1);

  double get headerFontSize =>
      lerp(MediaQuery.of(context).size.shortestSide * 0.04, MediaQuery.of(context).size.shortestSide * 0.06);

  // to control subheader font and margin
  double get subheaderTopMargin => lerp(50, MediaQuery.of(context).size.height * 0.15);

  double get subheaderFontSize => lerp(0, MediaQuery.of(context).size.shortestSide * 0.05);

  // to control BMI text
  double get bmiFontSize =>
      lerp(MediaQuery.of(context).size.shortestSide * 0.08, MediaQuery.of(context).size.shortestSide * 0.15);

  double get bmiTopMargin => lerp(
      MediaQuery.of(context).size.height * 0.05 - MediaQuery.of(context).size.shortestSide * 0.04,
      MediaQuery.of(context).size.height * 0.5);

  double get bmiRightMargin => lerp(0, (MediaQuery.of(context).size.width - 64) / 4);

  // to control BMI Unit text
  double get unitFontSize =>
      lerp(MediaQuery.of(context).size.shortestSide * 0.03, MediaQuery.of(context).size.shortestSide * 0.05);

  // to control BMI range
  double get rangeTextFontSize =>
      lerp(MediaQuery.of(context).size.shortestSide * 0.04, MediaQuery.of(context).size.shortestSide * 0.06);

  // to control container radius
  double get containerRadius => lerp(32, 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      //<-- initialize a controller
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); //<-- and remember to dispose it!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
            height: lerp(MediaQuery.of(context).size.height * 0.15, maxHeight),
            left: 0,
            right: 0,
            bottom: 0,
            child: StreamBuilder<double>(
                stream: HomeBlocProvider.of(context).mainPagerStream,
                builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
                  double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
                  double elevation = pageOffset > 0 ? 0 : 1 - pageOffset;
                  return Transform.translate(
                    offset: Offset(0, getYOffset(pageOffset, MediaQuery.of(context).size.height)),
                    child: GestureDetector(
                      onTap: _toggle,
                      onVerticalDragUpdate: _handleDragUpdate,
                      onVerticalDragEnd: _handleDragEnd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(containerRadius)),
                        ),
                        child: Stack(
                          children: <Widget>[
                            OpenCloseIcon(
                              iconSize: openCloseIconSize,
                              topMargin: openCloseIconMargin,
                            ),
                            SheetHeader(
                              fontSize: headerFontSize,
                              topMargin: headerTopMargin,
                            ),
                            SheetSubHeader(
                              fontSize: subheaderFontSize,
                              topMargin: subheaderTopMargin,
                              opacity: _controller.value,
                            ),
                            BMIText(
                              fontSize: bmiFontSize,
                              rightMargin: bmiRightMargin,
                              topMargin: bmiTopMargin,
                            ),
                            BMIRangeText(
                              fontSize: rangeTextFontSize,
                              opacity: _controller.value,
                            ),
                            UnitText(
                              fontSize: unitFontSize,
                              opacity: _controller.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
      },
    );
  }

  double getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset > 0) {
      yOffset = height * pageOffset * 0.25;
    }
    return yOffset;
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }
}

class OpenCloseIcon extends StatelessWidget {
  final double iconSize;
  final double topMargin;

  const OpenCloseIcon({Key key, @required this.iconSize, @required this.topMargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: 0,
      child: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white70,
        size: iconSize,
      ),
    );
  }
}

class SheetSubHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;
  final double opacity;

  const SheetSubHeader({Key key, @required this.fontSize, @required this.topMargin, @required this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      right: 0,
      left: 0,
      child: Opacity(
        opacity: opacity,
        child: Text(
          AppTranslations.of(context).text("bmi_description"),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader({Key key, @required this.fontSize, @required this.topMargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text(
        AppTranslations.of(context).text("bmi"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class BMIRangeText extends StatelessWidget {
  final double fontSize;
  final double opacity;

  const BMIRangeText({
    Key key,
    @required this.fontSize,
    @required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.8),
          child: StoreConnector<AppState, User>(
            converter: (Store<AppState> store) => store.state.user,
            builder: (BuildContext context, User user) {
              return Text(
                AppTranslations.of(context).text(getBMIRangeString(user.bmi)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String getBMIRangeString(double userBmi) {
    for (var idealBMI in idealBMIList) {
      if (idealBMI.start < userBmi && idealBMI.end > userBmi) {
        return idealBMI.label;
      }
    }
    return '';
  }

  String getBMIRangeColor(double userBmi) {
    for (var idealBMI in idealBMIList) {
      if (idealBMI.start < userBmi && idealBMI.end > userBmi) {
        return idealBMI.color;
      }
    }
    return '#ffffff';
  }
}

class BMIText extends StatelessWidget {
  final double fontSize;
  final double topMargin;
  final double rightMargin;

  const BMIText({Key key, @required this.fontSize, @required this.topMargin, @required this.rightMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      right: rightMargin,
      child: StoreConnector<AppState, User>(
        converter: (Store<AppState> store) => store.state.user,
        builder: (BuildContext context, User user) {
          return Text(
            format(user.bmi),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );
  }
}

class UnitText extends StatelessWidget {
  final double fontSize;
  final double opacity;

  const UnitText({
    Key key,
    @required this.fontSize,
    @required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child: Text(
            AppTranslations.of(context).text("bmi_unit"),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
