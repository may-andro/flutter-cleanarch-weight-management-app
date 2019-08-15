import 'package:flutter/material.dart';

import 'add_weight_bloc.dart';

class AddWeightBlocProvider extends InheritedWidget {
  final AddWeightBloc bloc;

  const AddWeightBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AddWeightBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AddWeightBlocProvider) as AddWeightBlocProvider).bloc;
  }
}
