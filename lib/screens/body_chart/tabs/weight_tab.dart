import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/body_chart/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/description_text.dart';
import 'package:flutter_weighter/widget/highlighted_value_text.dart';
import 'package:flutter_weighter/widget/title_text.dart';
import 'package:flutter_weighter/widget/vertical_spacer.dart';
import 'package:redux/redux.dart';

class WeightTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleText(
              label: AppTranslations.of(context).text("description"),
              isCenter: false,
            ),
            DescriptionText(
              label: AppTranslations.of(context).text("body_chart_tab1_description"),
            ),
            VerticalSpacer(
              height: 32,
            ),
            TitleText(
              label: AppTranslations.of(context).text("body_chart_tab1_subtitle2"),
              isCenter: false,
            ),
            buildFormula(context),
            VerticalSpacer(
              height: 32,
            ),
            TitleText(
              label: AppTranslations.of(context).text("body_chart_tab1_subtitle3"),
              isCenter: false,
            ),
            buildWeightValue(context),
          ],
        ),
      ),
    );
  }

  buildFormula(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.user,
      builder: (BuildContext context, User user) {
        return DescriptionText(
          label: user.gender == GENDER_MALE_CODE
              ? AppTranslations.of(context).text("body_chart_tab1_formula_male")
              : AppTranslations.of(context).text("body_chart_tab1_formula_female"),
        );
      },
    );
  }

  buildWeightValue(BuildContext context) {
    return StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.user,
      builder: (BuildContext context, User user) {
        return HighlightedValueText(
          label:
              '${BodyChartBlocProvider.of(context).calculateFatValue(user.gender, user.height)} ${AppTranslations.of(context).text("kg")}',
        );
      },
    );
  }
}
