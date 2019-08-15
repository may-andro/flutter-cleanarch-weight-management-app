import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = SettingsBlocProvider.of(context);
    return BaseSliverHeader(
      title: AppTranslations.of(context).text("setting_language"),
      iconData: Icons.close,
      onBackClick: () {
        _bloc.pageNavigationSink.add(NAVIGATE_TO_SETTINGS_TAB);
      },
      bodyWidget: _buildLanguagesList(context),
    );
  }

  _buildLanguagesList(BuildContext context) {
    final List<LanguageItem> languagesList = [
      LanguageItem('en', AppTranslations.of(context).text("english")),
      LanguageItem('es', AppTranslations.of(context).text("spanish"))
    ];

    return StoreConnector<AppState, Locale>(
        converter: (Store<AppState> store) => store.state.locale,
        builder: (BuildContext context, Locale locale) {
          return ListView.builder(
            itemCount: languagesList.length,
            itemBuilder: (context, index) {
              return _LanguageItemWidget(
                languageItem: languagesList[index],
                selectedLocale: locale,
              );
            },
          );
        });
  }
}

class _LanguageItemWidget extends StatelessWidget {
  final LanguageItem languageItem;
  final Locale selectedLocale;

  _LanguageItemWidget({@required this.languageItem, @required this.selectedLocale});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selectedLocale.languageCode == languageItem.languageCode) {
          return null;
        }
        Locale locale = Locale(languageItem.languageCode, "");
        _setLocaleInPreference(locale).then((val) {
          StoreProvider.of<AppState>(context).dispatch(UpdateLocaleAction(locale: locale));
        });
      },
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.language,
              color: selectedLocale.languageCode == languageItem.languageCode
                  ? Theme.of(context).primaryColor
                  : Colors.black87,
            ),
          ),
          Text(
            languageItem.label,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.shortestSide * 0.04,
              color: selectedLocale.languageCode == languageItem.languageCode
                  ? Theme.of(context).primaryColor
                  : Colors.black87,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: selectedLocale.languageCode == languageItem.languageCode
                ? Icon(
                    Icons.done,
                    color: Theme.of(context).primaryColor,
                  )
                : Offstage(),
          )
        ],
      ),
    );
  }

  Future _setLocaleInPreference(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_LOCALE, locale.languageCode);
  }
}

class LanguageItem {
  String languageCode;
  String label;

  LanguageItem(this.languageCode, this.label);
}
