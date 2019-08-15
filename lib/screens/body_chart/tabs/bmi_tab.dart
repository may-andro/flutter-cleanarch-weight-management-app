import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/body_chart/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';

class BMITab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: FittedBox(
          child: DataTable(
            horizontalMargin: 16,
            columnSpacing: 32,
            columns: [
              getTitleDataColumn(AppTranslations.of(context).text("body_chart_tab2_header_left")),
              getTitleDataColumn(AppTranslations.of(context).text("body_chart_tab2_header_right")),
            ],
            rows: idealBMIList
                .map(
                  (bmi) => DataRow(cells: [
                    getDataCell(
                        BodyChartBlocProvider.of(context).getBMIValue(bmi,
                            AppTranslations.of(context).text("less_then"), AppTranslations.of(context).text("above")),
                        bmi.color),
                    getDataCell(AppTranslations.of(context).text(bmi.label), bmi.color),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  DataColumn getTitleDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(color: Color(getColorHexFromStr(TEXT_COLOR_BLACK))),
      ),
    );
  }

  DataCell getDataCell(String label, String color) {
    return DataCell(
      Text(
        label,
        style: TextStyle(color: Color(getColorHexFromStr(color))),
      ),
    );
  }
}
