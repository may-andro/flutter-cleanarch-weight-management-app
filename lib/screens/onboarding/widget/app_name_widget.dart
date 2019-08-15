import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';

class AppNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = OnboardingBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.2,
      left: 0,
      right: 0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
            double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
            return Transform.scale(
              scale: _getScaleOffset(pageOffset),
              child: Transform.translate(
                offset: Offset(-_getXOffset(pageOffset, MediaQuery.of(context).size.width),
                    -_getYOffset(pageOffset, MediaQuery.of(context).size.height)),
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'WEIGHTER',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: MediaQuery.of(context).size.shortestSide * 0.15),
                      textAlign: TextAlign.center,
                    )),
              ),
            );
          }),
    );
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset > 3 && pageOffset <= 4) {
      xOffset = width * 0.5 * (pageOffset - 3);
    } else if (pageOffset > 4 && pageOffset <= 5) {
      xOffset = -width * 0.5 * (pageOffset - 5);
    } else {
      xOffset = 0;
    }
    return xOffset;
  }

  double _getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset <= 1) {
      yOffset = height * 0.15 * pageOffset;
    } else {
      yOffset = height * 0.15;
    }
    return yOffset;
  }

  double _getScaleOffset(double pageOffset) {
    double scale = 0.5;
    if (pageOffset >= 0 && pageOffset <= 1) {
      scale = 1 - pageOffset / 2;
    } else {
      scale = 0.5;
    }
    return scale;
  }
}
