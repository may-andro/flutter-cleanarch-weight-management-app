import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SettingsBlocProvider.of(context);
    return BaseSliverHeader(
      title: AppTranslations.of(context).text("setting_about"),
      iconData: Icons.close,
      onBackClick: () {
        bloc.verticalPagerNavigationSink.add(NAVIGATE_TO_SETTINGS_LIST_TAB);
      },
      bodyWidget: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDescription(context),
          ],
        ),
      ),
    );
  }

  _buildDescription(BuildContext context) {
    return Container(
        child: RichText(
            text: TextSpan(
                // set the default style for the children TextSpans
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                children: [
          TextSpan(
              text: AppTranslations.of(context).text("app_name"),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: MediaQuery.of(context).size.shortestSide * 0.06)),
          TextSpan(
            text: AppTranslations.of(context).text("app_description"),
            style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.045),
          ),
        ])));
  }
}
