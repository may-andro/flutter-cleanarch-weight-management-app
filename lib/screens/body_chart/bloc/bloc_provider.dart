import 'package:flutter/material.dart';

import 'body_chart_bloc.dart';


class BodyChartBlocProvider extends InheritedWidget {
  final BodyChartBloc bloc;

  const BodyChartBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static BodyChartBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BodyChartBlocProvider) as BodyChartBlocProvider).bloc;
  }
}
