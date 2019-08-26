import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/notification_item.dart';
import 'package:flutter_weighter/redux/app_actions.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/onboarding/onboarding_page.dart';
import 'package:flutter_weighter/screens/setting/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/base_sliver_header.dart';
import 'package:flutter_weighter/widget/dialog_content.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingListTab extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  SettingListTab() : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    final bloc = SettingsBlocProvider.of(context);
    return BaseSliverHeader(
      title: AppTranslations.of(context).text("setting"),
      bodyWidget: ListView(
        children: <Widget>[
          StoreConnector<AppState, NotificationItem>(
              converter: (Store<AppState> store) => store.state.notificationItem,
              builder: (BuildContext context, NotificationItem notificationItem) {
                return _SettingItemWidget(
                  iconData: Icons.notifications_active,
                  label: AppTranslations.of(context).text("setting_notification"),
                  onPress: () {
                    _editNotificationReminderDialog(context, notificationItem);
                  },
                  rightLabel: AppTranslations.of(context).text(notificationItem.label),
                );
              }),
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

  Widget _notificationItem(NotificationItem notificationItem, NotificationItem groupNotificationItem, Function onClick,
      BuildContext context) {
    return RadioListTile<NotificationItem>(
      title: Text(
        AppTranslations.of(context).text(notificationItem.label),
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
      ),
      value: notificationItem,
      groupValue: groupNotificationItem,
      onChanged: onClick,
    );
  }

  Future<bool> _editNotificationReminderDialog(BuildContext context, NotificationItem notificationItem) {
    var store = StoreProvider.of<AppState>(context);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: DialogContent(
                title: AppTranslations.of(context).text("setting_notification"),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    reverse: false,
                    itemBuilder: (_, int index) => _notificationItem(
                      notificationItemList[index],
                      notificationItem,
                      (value) {
                        Navigator.of(context).pop();
                        store.dispatch(UpdateNotificationReminderAction(notificationItem: value));
                        _scheduleNotification(value);
                      },
                      context,
                    ),
                    itemCount: notificationItemList.length,
                  ),
                ),
                positiveText: '',
                negativeText: '',
                onNegativeCallBack: () {
                  Navigator.of(context).pop();
                },
                onPositiveCallback: () {
                  Navigator.of(context).pop();
                },
              ));
        });
  }

  Future<void> _scheduleNotification(NotificationItem notificationItem) async {
    if (notificationItem.id == SELECTED_NOTIFICATION_NONE) {
      await flutterLocalNotificationsPlugin.cancelAll();
      return;
    }

    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: null);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'weighter',
      'weighter',
      'weighter',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    var time = new Time(18, 0, 0);

    if (notificationItem.id == SELECTED_NOTIFICATION_DAILY) {
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Daily reminder',
        'Update your weight today',
        time,
        platformChannelSpecifics,
      );
    } else {
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'Weekly reminder',
        'Updat your weight for this week',
        Day.Monday,
        time,
        platformChannelSpecifics,
      );
    }
  }
}

class _SettingItemWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function onPress;
  final String rightLabel;

  _SettingItemWidget({
    @required this.iconData,
    @required this.label,
    @required this.onPress,
    this.rightLabel = '',
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
            Spacer(),
            Text(
              rightLabel,
              style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.04, color: Colors.grey),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
