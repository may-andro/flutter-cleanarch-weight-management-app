import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/body_chart/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:redux/redux.dart';

class BFPTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.user,
      builder: (BuildContext context, User user) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                columns: [
                  getTitleDataColumn(AppTranslations.of(context).text("body_chart_tab3_header_left")),
                  getTitleDataColumn(
                      "${user.gender == GENDER_FEMALE_CODE ? AppTranslations.of(context).text("gender_female") : AppTranslations.of(context).text("gender_male")}"),
                ],
                rows: idealFatList
                    .map(
                      (bfp) => DataRow(cells: [
                        getDataCell(AppTranslations.of(context).text(bfp.label), bfp.color),
                        getDataCell(
                            BodyChartBlocProvider.of(context)
                                .fatValue(user.gender, bfp, AppTranslations.of(context).text("above")),
                            bfp.color),
                      ]),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
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
