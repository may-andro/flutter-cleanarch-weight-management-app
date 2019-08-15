import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = OnboardingBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.width * 0.05,
      right: 0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
            double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
            return Transform.scale(
              scale: _getScaleOffset(pageOffset),
              child: Transform.translate(
                offset: Offset(-_getXOffset(pageOffset, MediaQuery.of(context).size.height),
                    MediaQuery.of(context).size.height * 0.02),
                child: ClipOval(
                  child: Container(
                      color: Theme.of(context).primaryColor,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () => _bloc.createUser(StoreProvider.of<AppState>(context)),
                        icon: const Icon(Icons.done),
                      )),
                ),
              ),
            );
          }),
    );
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset > 3 && pageOffset <= 4) {
      xOffset = width * 0.025 * (pageOffset - 3);
    } else if (pageOffset > 4 && pageOffset <= 5) {
      xOffset = width * 0.025 * (5 - pageOffset);
    } else {
      xOffset = 0;
    }
    return xOffset;
  }

  double _getScaleOffset(double pageOffset) {
    double scale = 0.5;
    if (pageOffset > 3 && pageOffset <= 4) {
      scale = (pageOffset - 3);
    } else if (pageOffset > 4 && pageOffset <= 5) {
      scale = (5 - pageOffset);
    } else {
      scale = 0;
    }
    return scale;
  }
}
