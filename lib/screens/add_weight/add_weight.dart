import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';
import 'package:flutter_weighter/widget/rounded_button.dart';
import 'package:flutter_weighter/widget/vertical_spacer.dart';
import 'package:flutter_weighter/widget/weight_card.dart';
import 'package:redux/redux.dart';

import 'bloc/add_weight_bloc.dart';
import 'bloc/bloc_provider.dart';

class AddWeight extends StatefulWidget {
  @override
  _AddWeightState createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  AddWeightBloc _addWeightBloc;

  @override
  void initState() {
    super.initState();
    _addWeightBloc = AddWeightBloc();
  }

  @override
  Widget build(BuildContext context) {
    return AddWeightBlocProvider(
      bloc: _addWeightBloc,
      child: Scaffold(
        body: BaseSliverHeader(
          title: AppTranslations.of(context).text("add_weight_label"),
          bodyWidget: buildContent(),
        ),
      ),
    );
  }

  Widget buildContent() {
    return StoreConnector<AppState, User>(
        converter: (Store<AppState> store) => store.state.user,
        builder: (BuildContext context, User user) {
          _addWeightBloc.weight = user.weight;
          return Column(
            children: <Widget>[
              _TitleText(lastUpdated: user.last_updated),
              VerticalSpacer(
                height: 24,
              ),
              buildWeightCard(),
              VerticalSpacer(
                height: 24,
              ),
              _SelectedWeightText(),
              VerticalSpacer(
                height: 24,
              ),
              _UpdateButton(currentWeight: user.weight)
            ],
          );
        });
  }

  buildWeightCard() {
    return StreamBuilder<double>(
        stream: _addWeightBloc.selectedWeightStream,
        builder: (context, snapshot) {
          double selectedWeight = snapshot.hasData ? snapshot.data : _addWeightBloc.weight.toDouble();
          return WeightCard(
            weight: selectedWeight.toInt(),
            onChanged: (val) {
              _addWeightBloc.weight = val.toDouble();
              _addWeightBloc.selectedWeightSink.add(val.toDouble());
            },
          );
        });
  }
}

class _TitleText extends StatelessWidget {
  final String lastUpdated;

  _TitleText({@required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        '${AppTranslations.of(context).text("update_weight_label")} \n $lastUpdated',
        style: TextStyle(
            color: Colors.black87, fontSize: MediaQuery.of(context).size.shortestSide * 0.04, letterSpacing: 0.8),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SelectedWeightText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _addWeightBloc = AddWeightBlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("add_weight_result_label"),
            style: TextStyle(
                color: Colors.black54, fontSize: MediaQuery.of(context).size.shortestSide * 0.05, letterSpacing: 0),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
          StreamBuilder<double>(
              stream: _addWeightBloc.selectedWeightStream,
              builder: (context, snapshot) {
                int selectedWeight = snapshot.hasData ? snapshot.data.toInt() : _addWeightBloc.weight.toInt();
                return Text(
                  '$selectedWeight ${AppTranslations.of(context).text("kg")}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: MediaQuery.of(context).size.shortestSide * 0.07,
                      letterSpacing: 0.8),
                  softWrap: true,
                  textAlign: TextAlign.left,
                );
              }),
        ],
      ),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  final double currentWeight;

  _UpdateButton({@required this.currentWeight});

  @override
  Widget build(BuildContext context) {
    final _addWeightBloc = AddWeightBlocProvider.of(context);
    final snackBar = SnackBar(
      content: Text(AppTranslations.of(context).text("no_update")),
    );
    return StreamBuilder<Object>(
        stream: _addWeightBloc.selectedWeightStream,
        builder: (context, snapshot) {
          double selectedWeight = snapshot.hasData ? snapshot.data : _addWeightBloc.weight.toDouble();
          bool isChanged = selectedWeight != currentWeight;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
            child: RoundedButton(
              onPressed: () {
                if (isChanged) {
                  //to update the User Table
                  _addWeightBloc.updateUserTable(selectedWeight, StoreProvider.of<AppState>(context)).then((value) {
                    Navigator.of(context).pop();
                  });
                } else {
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              text: AppTranslations.of(context).text("update"),
            ),
          );
        });
  }
}
