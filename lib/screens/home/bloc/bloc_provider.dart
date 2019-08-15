import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/home/bloc/home_bloc.dart';


class HomeBlocProvider extends InheritedWidget {
  final HomeBloc bloc;

  const HomeBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static HomeBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(HomeBlocProvider) as HomeBlocProvider).bloc;
  }
}
