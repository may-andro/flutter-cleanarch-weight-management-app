import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/onboarding/widget/onboarding_header_text.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/rounded_button.dart';

class GenderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: <Widget>[_buildTitleLabel(context), buildGenderSelector(context)],
        ));
  }

  _buildTitleLabel(BuildContext context) => Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: OnBoardingHeaderText(
            text: '${AppTranslations.of(context).text("gender_label")} ${OnboardingBlocProvider.of(context).name}. ${AppTranslations.of(context).text("gender_label2")}'),
      );

  Widget buildGenderSelector(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            genderSelector(context),
            SizedBox(
              height: MediaQuery.of(context).size.shortestSide * 0.2,
            ),
            _buildButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 24.0),
      child: RoundedButton(
        onPressed: () {
	        print('GenderTab._buildButton ${OnboardingBlocProvider.of(context).genderCode}');
	        OnboardingBlocProvider.of(context).pageNavigationSink.add(NAVIGATE_TO_AGE_TAB);
        },
        text: AppTranslations.of(context).text("next"),
      ),
    );
  }

  Widget genderSelector(BuildContext context) {
    final bloc = OnboardingBlocProvider.of(context);
    return StreamBuilder<int>(
        stream: bloc.selectedGenderStream,
        builder: (context, snapshot) {
          int genderCode = snapshot.hasData ? snapshot.data : bloc.genderCode;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.shortestSide * 0.1, vertical: MediaQuery.of(context).size.shortestSide * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // male
                genderContainerItem('assets/images/masculine.svg', AppTranslations.of(context).text("gender_male"),
                    genderCode == GENDER_MALE_CODE, context, () {
                  bloc.selectedGenderSink.add(GENDER_MALE_CODE);
                  bloc.genderCode = GENDER_MALE_CODE;
                }),
                // female
                genderContainerItem('assets/images/femenine.svg', AppTranslations.of(context).text("gender_female"),
                    genderCode == GENDER_FEMALE_CODE, context, () {
                  bloc.selectedGenderSink.add(GENDER_FEMALE_CODE);
                  bloc.genderCode = GENDER_FEMALE_CODE;
                })
              ],
            ),
          );
        });
  }

  Widget genderContainerItem(String image, String label, isSelected, BuildContext context, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            image,
            width: MediaQuery.of(context).size.shortestSide * (isSelected ? 0.3 : 0.2),
            height: MediaQuery.of(context).size.shortestSide * (isSelected ? 0.3 : 0.2),
            fit: BoxFit.contain,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
          ),
        ],
      ),
    );
  }
}
