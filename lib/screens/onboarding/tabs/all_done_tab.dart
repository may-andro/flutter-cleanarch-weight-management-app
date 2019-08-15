import 'package:flutter/material.dart';
import 'package:flutter_lottie/flutter_lottie.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/onboarding/widget/onboarding_header_text.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';

class AllDoneTab extends StatefulWidget {
  AllDoneTab({
    @required this.onFinishClick,
    @required this.animationController,
  });

  final Function onFinishClick;
  final AnimationController animationController;

  @override
  _AllDoneTabState createState() => _AllDoneTabState();
}

class _AllDoneTabState extends State<AllDoneTab> with TickerProviderStateMixin {
  LottieController controller;
  Animation<double> shrinkAnimation;

  double get shrinkFraction => shrinkAnimation?.value ?? 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
	  return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[buildMessage(), Expanded(child: buildImage()), buttonStart()],
      ),
    );
  }

  buildMessage() {
	  return Padding(
	    padding: const EdgeInsets.all(8.0),
	    child: OnBoardingHeaderText(text: '${AppTranslations.of(context).text("all_done_message")}'),
	  );
  }

  buildImage() {
    return LottieView.fromFile(
      filePath: "animations/account.json",
      autoPlay: true,
      loop: true,
      reverse: true,
      onViewCreated: (controller) {
        this.controller = controller;
      },
    );
  }

  buttonStart() {
    return LayoutBuilder(builder: (context, constraints) {
      shrinkAnimation = Tween<double>(
        begin: constraints.maxWidth,
        end: 52,
      ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.05, 0.15),
      ));

      return AnimatedBuilder(
          animation: widget.animationController,
          builder: (context, child) {
            Decoration decoration = BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColor,
            );

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: InkWell(
                onTap: widget.onFinishClick,
                child: Container(
                  height: MediaQuery.of(context).size.shortestSide * 0.125,
                  width: shrinkFraction,
                  decoration: decoration,
	                child: Center(
	                  child: Text(AppTranslations.of(context).text("finish"),
			                style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.shortestSide * 0.04, letterSpacing: 0.75, fontWeight: FontWeight.w500)),
	                ),
                ),
              ),
            );
          });
    });
  }
}
