import 'package:flutter/material.dart';

import 'onboarding_bloc.dart';

class OnboardingBlocProvider extends InheritedWidget {
  final OnBoardingBloc bloc;

  const OnboardingBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static OnBoardingBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(OnboardingBlocProvider) as OnboardingBlocProvider).bloc;
  }
}
