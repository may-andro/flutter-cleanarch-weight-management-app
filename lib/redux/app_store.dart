
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/redux/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Store<AppState>> createStore() async {
	SharedPreferences prefs = await SharedPreferences.getInstance();
	return Store<AppState>(
		appReducer,
		initialState: AppState.initial(prefs),
		distinct: true,
	);
}