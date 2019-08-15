import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/setting/bloc/settings_bloc.dart';


class SettingsBlocProvider extends InheritedWidget {
  final SettingBloc bloc;

  const SettingsBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static SettingBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SettingsBlocProvider) as SettingsBlocProvider).bloc;
  }
}
