import 'package:flutter/material.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/rounded_button.dart';
import 'package:flutter_lottie/flutter_lottie.dart';

class WelcomeTab extends StatelessWidget {
  WelcomeTab({
    @required AnimationController animationController,
    @required this.onPressed
  }) : onboardingEnterAnimation = WelcomeTabEnterAnimation(animationController);

  final Function onPressed;
  final WelcomeTabEnterAnimation onboardingEnterAnimation;
  LottieController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: buildImage(context)),
          buildDescriptionLabel(context),
          buttonStart(context)
        ],
      ),
    );
  }

  buildImage(BuildContext context) => FadeTransition(
    opacity: onboardingEnterAnimation.welcomeLabelOpacity,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: LottieView.fromFile(
        filePath: "animations/record.json",
        autoPlay: true,
        loop: true,
        reverse: true,
        onViewCreated: (controller) {
          this.controller = controller;
        },
      ),
    ),
  );

  buildDescriptionLabel(BuildContext context) => FadeTransition(
    opacity: onboardingEnterAnimation.subheaderOpacity,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: Text(
	      AppTranslations.of(context).text("welcome_message"),
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget buttonStart(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.diagonal3Values(
        onboardingEnterAnimation.buttonScale.value,
        onboardingEnterAnimation.buttonScale.value,
        1.0,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        child: RoundedButton(
          onPressed: onPressed,
          isClickable: true,
          text: AppTranslations.of(context).text("welcome_button"),
        ),
      ),
    );
  }
}

class WelcomeTabEnterAnimation {
  WelcomeTabEnterAnimation(this.controller)
      : welcomeLabelOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.0,
              0.5,
              curve: Curves.easeInToLinear,
            ),
          ),
        ),
        subheaderOpacity = new Tween(begin: 0.0, end: 0.85).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.25,
              0.7,
              curve: Curves.easeIn,
            ),
          ),
        ),
        buttonScale = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.4,
              1.0,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        termsAndConditions = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.8,
              1.0,
              curve: Curves.linear,
            ),
          ),
        );

  final AnimationController controller;
  final Animation<double> welcomeLabelOpacity;
  final Animation<double> subheaderOpacity;
  final Animation<double> buttonScale;
  final Animation<double> termsAndConditions;
}
