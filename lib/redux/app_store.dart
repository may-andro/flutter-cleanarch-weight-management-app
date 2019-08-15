
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/redux/app_reducer.dart';
import 'package:redux/redux.dart';

Future<Store<AppState>> createStore() async {

	return Store<AppState>(
		appReducer,
		initialState: AppState.initial(),
		distinct: true,
	);
}