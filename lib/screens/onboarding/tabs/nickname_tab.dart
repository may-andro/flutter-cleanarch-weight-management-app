import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/onboarding/widget/onboarding_header_text.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/rounded_button.dart';

class NickNameTab extends StatefulWidget {
  // Controllers
  @override
  _NickNameTabState createState() => _NickNameTabState();
}

class _NickNameTabState extends State<NickNameTab> {
  final TextEditingController nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return buildScrollPage(context);
  }

  Widget buildScrollPage(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        height: MediaQuery.of(context).size.height * 0.7,
        child: buildFormContainer(context));
  }

  Widget buildFormContainer(BuildContext context) {
    return Stack(
      children: <Widget>[buildTitleLabel(context), buildForm(context)],
    );
  }

  buildTitleLabel(BuildContext context) => Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: OnBoardingHeaderText(text: AppTranslations.of(context).text("nickname_label")),
      );

  Widget buildForm(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.1,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildTextForm(),
              SizedBox(
                height: MediaQuery.of(context).size.shortestSide * 0.2,
              ),
              buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: TextFormField(
        style: TextStyle(
            color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
            fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
            letterSpacing: 1.2),
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: AppTranslations.of(context).text("nickname_hint"),
          helperText: AppTranslations.of(context).text("nickname_helper"),
          helperStyle: TextStyle(
              color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
              fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
              letterSpacing: 0.8),
          errorStyle: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.03, letterSpacing: 0.8),
        ),
        keyboardType: TextInputType.text,
        maxLength: 20,
        controller: nameController,
        validator: (val) =>
            val.length == 0 ? AppTranslations.of(context).text("nickname_validation_empty") : val.length < 2 ? AppTranslations.of(context).text("nickname_validation_invalid") : null,
      ),
    );
  }

  Widget buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
      child: RoundedButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            OnboardingBlocProvider.of(context).name = nameController.value.text;
            OnboardingBlocProvider.of(context).pageNavigationSink.add(NAVIGATE_TO_GENDER_TAB);
          }
        },
        text: AppTranslations.of(context).text("next"),
      ),
    );
  }
}
