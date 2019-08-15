import 'package:flutter/material.dart';
import 'package:flutter_weighter/model/weight_history.dart';
import 'package:flutter_weighter/screens/weight_history/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/weight_history/bloc/weigth_history_bloc.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';

class WeightTrendPage extends StatefulWidget {
  @override
  _WeightTrendPageState createState() => _WeightTrendPageState();
}

class _WeightTrendPageState extends State<WeightTrendPage> {
  WeightHistoryBloc _weightHistoryBloc;

  @override
  void initState() {
    super.initState();
    _weightHistoryBloc = WeightHistoryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return WeightHistoryBlocProvider(
      bloc: _weightHistoryBloc,
      child: Scaffold(
        body: BaseSliverHeader(
          title: AppTranslations.of(context).text("history"),
          bodyWidget: buildContent(),
        ),
      ),
    );
  }

  buildContent() {
    return Stack(
      children: <Widget>[
        buildTimeline(),
        StreamBuilder<List<WeightHistory>>(
            stream: _weightHistoryBloc.notifyWeightHistoryListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                    return true;
                  },
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _CardItem(weightHistory: snapshot.data[index]);
                      }),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ],
    );
  }

  Widget buildTimeline() {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 40.0,
      child: Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final double dotSize = 12.0;
  final WeightHistory weightHistory;

  _CardItem({@required this.weightHistory});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: MediaQuery.of(context).size.shortestSide * 0.07),
          child: Container(
            height: dotSize,
            width: dotSize,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${weightHistory.weight.ceil().toInt()} ${AppTranslations.of(context).text("kg")}',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.05),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      weightHistory.difference.isEmpty
                          ? ''
                          : '${weightHistory.difference} ${AppTranslations.of(context).text("kg")}',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.04, color: Colors.grey),
                    ),
                  )
                ],
              ),
              Text(
                '${weightHistory.date} ${AppTranslations.of(context).text("at")} ${weightHistory.time}',
                style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.03, color: Colors.grey),
              )
            ],
          ),
        ),
      ],
    );
  }
}
