import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/home/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/home/widget/editable_selection_widget.dart';
import 'package:flutter_weighter/screens/home/widget/height_pager.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';

import 'package:flutter_weighter/widget/dialog_content.dart';
import 'package:redux/redux.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = HomeBlocProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StoreConnector<AppState, User>(
          converter: (Store<AppState> store) => store.state.user,
          builder: (BuildContext context, User user) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                EditableSelectionWidget(
                  label: AppTranslations.of(context).text("gender"),
                  value:
                      '${bloc.getGenderText(user.gender, AppTranslations.of(context).text("gender_male"), AppTranslations.of(context).text("gender_female"))}',
                  onPress: null,
                  iconData: null,
                ),
                StreamBuilder<int>(
                    stream: bloc.ageSelectionStream,
                    builder: (context, snapshotAge) {
                      String selectedAge = '${snapshotAge.hasData ? snapshotAge.data : user.age.toInt()}';
                      return EditableSelectionWidget(
                        label: AppTranslations.of(context).text("age"),
                        value: '$selectedAge ${AppTranslations.of(context).text("years")}',
                        onPress: () => _editAge(context, user.age + 1),
                        iconData: Icons.add,
                      );
                    }),
                StreamBuilder<int>(
                    stream: bloc.heightSelectionStream,
                    builder: (context, snapshotEdited) {
                      String currentHeight = '${snapshotEdited.hasData ? snapshotEdited.data : user.height.toInt()}';
                      return EditableSelectionWidget(
                        label: AppTranslations.of(context).text("height"),
                        value: '$currentHeight ${AppTranslations.of(context).text("cm")}',
                        onPress: () => _editHeight(
                            context, bloc.editedHeight == 0 ? user.height.toInt() : bloc.editedHeight.toInt()),
                        iconData: Icons.edit,
                      );
                    }),
                EditableSelectionWidget(
                  label: AppTranslations.of(context).text("weight"),
                  value: '${user.weight} ${AppTranslations.of(context).text("kg")}',
                  onPress: null,
                  iconData: null,
                ),
              ],
            );
          }),
    );
  }

  Future<bool> _editAge(BuildContext context, int age) {
    final bloc = HomeBlocProvider.of(context);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: DialogContent(
                title: AppTranslations.of(context).text("add_dialog_title"),
                child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        '${AppTranslations.of(context).text("add_dialog_subtitle")} $age ?',
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
                  bloc.editedAge = age - 1;
                  bloc.ageSelectionSink.add(age - 1);
                  Navigator.of(context).pop();
                },
                onPositiveCallback: () {
                  bloc.editedAge = age;
                  bloc.ageSelectionSink.add(age);
                  Navigator.of(context).pop();
                },
              ));
        });
  }

  Future<bool> _editHeight(BuildContext context, int height) {
    final bloc = HomeBlocProvider.of(context);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: DialogContent(
                title: AppTranslations.of(context).text("height_dialog_title"),
                child: HeightPager(
                  bloc: bloc,
                  currentHeight: height,
                ),
                positiveText: AppTranslations.of(context).text("yes"),
                negativeText: AppTranslations.of(context).text("dismiss"),
                onNegativeCallBack: () {
                  Navigator.of(context).pop();
                  bloc.heightSelectionSink.add(height);
                  bloc.focusedHeightPagerSink.add((height - MIN_HEIGHT).toDouble());
                },
                onPositiveCallback: () {
                  Navigator.of(context).pop();
                },
              ));
        });
  }
}
