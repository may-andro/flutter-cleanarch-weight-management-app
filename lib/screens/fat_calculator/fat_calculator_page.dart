import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/text_utility.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';
import 'package:flutter_weighter/widget/description_text.dart';
import 'package:flutter_weighter/widget/highlighted_value_text.dart';
import 'package:flutter_weighter/widget/title_text.dart';
import 'package:flutter_weighter/widget/vertical_spacer.dart';
import 'package:redux/redux.dart';

class FatCalculatorPage extends StatefulWidget {
  @override
  _FatCalculatorPageState createState() => _FatCalculatorPageState();
}

class _FatCalculatorPageState extends State<FatCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseSliverHeader(
        title: AppTranslations.of(context).text("bfp_title"),
        bodyWidget: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleText(
            label: AppTranslations.of(context).text("description"),
            isCenter: false,
          ),
          DescriptionText(
            label: AppTranslations.of(context).text("bfp_description"),
          ),
          VerticalSpacer(
            height: 32,
          ),
          TitleText(
            label: AppTranslations.of(context).text("formula"),
            isCenter: false,
          ),
          buildFormula(),
          VerticalSpacer(
            height: 32,
          ),
          TitleText(
            label: AppTranslations.of(context).text("bfp_sub_header_3"),
            isCenter: false,
          ),
          buildFatValue(),
        ],
      ),
    );
  }

  buildFormula() {
    return StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.user,
      builder: (BuildContext context, User user) {
        return DescriptionText(
          label: user.gender == GENDER_MALE_CODE
              ? AppTranslations.of(context).text("bfp_men_formula")
              : AppTranslations.of(context).text("bfp_women_formula"),
        );
      },
    );
  }

  buildFatValue() {
    return StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.user,
      builder: (BuildContext context, User user) {
        return HighlightedValueText(
          label: '${format(user.fat_percentage)} %',
        );
      },
    );
  }
}
