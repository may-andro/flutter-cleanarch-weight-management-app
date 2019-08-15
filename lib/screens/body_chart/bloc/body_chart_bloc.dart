import 'dart:async';

import 'package:flutter_weighter/model/ideal_bmi.dart';
import 'package:flutter_weighter/model/ideal_fat.dart';
import 'package:flutter_weighter/repository/repository.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/text_utility.dart';
import 'package:rxdart/rxdart.dart';

class BodyChartBloc {
  final _getUserBehaviorSubject = PublishSubject<bool>();
  Stream<bool> get getUserStream => _getUserBehaviorSubject.stream;
  Sink<bool> get getUserSink => _getUserBehaviorSubject.sink;

  dispose() {
    _getUserBehaviorSubject.close();
  }

  String fatValue(int genderCode, IdealFat bfp, String label) {
    return genderCode == GENDER_MALE_CODE
        ? '${bfp.startMale} ${bfp.endMale > 25 ? '' : '-'} ${bfp.endMale > 25 ? label : bfp.endMale}'
        : '${bfp.startFemale} ${bfp.endFemale > 32 ? '' : '-'} ${bfp.endFemale > 32 ? label : bfp.endFemale}';
  }

  String getBMIValue(IdealBMI bmi, String labelLess, String labelAbove) {
    return '${bmi.start == 0 ? labelLess : bmi.start} ${bmi.start == 0 || bmi.end > 40 ? '' : '-'} ${bmi.end > 40 ? labelAbove : bmi.end}';
  }

  String calculateFatValue(int genderCode, double height) {
    double idealWeight;
    double heightInInches = height / 2.54;
    if (genderCode == GENDER_MALE_CODE) {
      idealWeight = 52 + (1.9 * (heightInInches - 60));
    } else {
      idealWeight = 49 + (1.7 * (heightInInches - 60));
    }

    return format(idealWeight.ceil().toDouble());
  }
}
