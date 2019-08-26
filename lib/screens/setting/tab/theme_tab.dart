import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/theme_item.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/setting/widget/theme_pager.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';

class ThemeTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SettingsBlocProvider.of(context);
    return StreamBuilder<ThemeItem>(
        stream: bloc.themeSelectionStream,
        builder: (context, snapshot) {
          ThemeItem themeData = snapshot.hasData ? snapshot.data : StoreProvider.of<AppState>(context).state.themeData;
          return Container(
            color: Color(getColorHexFromStr(themeData.color)),
            child: BaseSliverHeader(
              title: AppTranslations.of(context).text("setting_theme"),
              titleColor: WHITE,
              iconData: Icons.close,
              onBackClick: () {
                bloc.pageNavigationSink.add(NAVIGATE_TO_SETTINGS_TAB);
              },
              bodyWidget: ThemePager(
                currentTheme: StoreProvider.of<AppState>(context).state.themeData,
              ),
            ),
          );
        });
  }
}
