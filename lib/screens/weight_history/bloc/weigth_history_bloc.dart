import 'dart:async';

import 'package:flutter_weighter/model/weight_history.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class WeightHistoryBloc {
  final _repository = Repository();

  final _mainPagerBehaviorSubject = PublishSubject<double>();
  Stream<double> get mainPagerStream => _mainPagerBehaviorSubject.stream;
  Sink<double> get mainPagerSink => _mainPagerBehaviorSubject.sink;

  final _selectedPageBehaviorSubject = PublishSubject<int>();
  Stream<int> get pageNavigationStream => _selectedPageBehaviorSubject.stream;
  Sink<int> get pageNavigationSink => _selectedPageBehaviorSubject.sink;

  final _notifyWeightHistoryListBehaviorSubject = PublishSubject<List<WeightHistory>>();
  Stream<List<WeightHistory>> get notifyWeightHistoryListStream => _notifyWeightHistoryListBehaviorSubject.stream;
  Sink<List<WeightHistory>> get notifyWeightHistoryListSink => _notifyWeightHistoryListBehaviorSubject.sink;

  WeightHistoryBloc() {
    _repository.getWeightHistoryList().then((list) {
      notifyWeightHistoryListSink.add(list);
    });
  }

  dispose() {
    _mainPagerBehaviorSubject.close();
    _selectedPageBehaviorSubject.close();
    _notifyWeightHistoryListBehaviorSubject.close();
  }
}
