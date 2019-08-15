import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/weight_history/bloc/weigth_history_bloc.dart';


class WeightHistoryBlocProvider extends InheritedWidget {
  final WeightHistoryBloc bloc;

  const WeightHistoryBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static WeightHistoryBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(WeightHistoryBlocProvider) as WeightHistoryBlocProvider).bloc;
  }
}
