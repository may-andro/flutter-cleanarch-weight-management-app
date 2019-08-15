import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/onboarding/onboarding_page.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';
import 'package:flutter_weighter/widget/dialog_content.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = SettingsBlocProvider.of(context);
    return BaseSliverHeader(
      title: AppTranslations.of(context).text("setting"),
      bodyWidget: ListView(
        children: <Widget>[
          _SettingItemWidget(
              iconData: Icons.language,
              label: AppTranslations.of(context).text("setting_language"),
              onPress: () {
                bloc.pageNavigationSink.add(NAVIGATE_TO_SETTINGS_LANGUAGE_TAB);
              }),
          _SettingItemWidget(
            iconData: Icons.color_lens,
            label: AppTranslations.of(context).text("setting_theme"),
            onPress: () {
              bloc.pageNavigationSink.add(NAVIGATE_TO_SETTINGS_THEME_TAB);
            },
          ),
          _SettingItemWidget(
            iconData: Icons.info,
            label: AppTranslations.of(context).text("setting_about"),
            onPress: () {
              bloc.verticalPagerNavigationSink.add(NAVIGATE_TO_SETTINGS_ABOUT_TAB);
            },
          ),
          _SettingItemWidget(
            iconData: Icons.feedback,
            label: AppTranslations.of(context).text("setting_feedback"),
            onPress: () => _launchEmail(),
          ),
          _SettingItemWidget(
            iconData: Icons.delete_forever,
            label: AppTranslations.of(context).text("setting_reset"),
            onPress: () => _resetApp(context),
          ),
        ],
      ),
    );
  }

  Future<bool> _resetApp(BuildContext context) {
    final bloc = SettingsBlocProvider.of(context);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: DialogContent(
                title: AppTranslations.of(context).text("reset_app"),
                child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        '${AppTranslations.of(context).text("reset_app_message")}',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w300,
                            fontSize: MediaQuery.of(context).size.shortestSide * 0.05),
                        textAlign: TextAlign.center,
                      ),
                    )),
                positiveText: AppTranslations.of(context).text("yes"),
                negativeText: AppTranslations.of(context).text("dismiss"),
                onNegativeCallBack: () {
                  Navigator.of(context).pop();
                },
                onPositiveCallback: () {
                  bloc.resetApp().then((val) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) => OnBoardingPage()),
                      ModalRoute.withName('/'),
                    );
                  });
                },
              ));
        });
  }

  _launchEmail() async {
    const url = 'mailto:ait11538@gmail.com?subject=Feedback&body=';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _SettingItemWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function onPress;

  _SettingItemWidget({
    @required this.iconData,
    @required this.label,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPress,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                iconData,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
            ),
          ],
        ),
      ),
    );
  }
}
