import 'package:flutter/material.dart';
import 'package:flutter_weighter/utility/color_utility.dart';

class OnBoardingHeaderText extends StatelessWidget {
  final String text;

  const OnBoardingHeaderText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 0, top: 0, bottom: 16),
      child: Text(
        text,
        style: TextStyle(
            color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
            fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
            letterSpacing: 0.8),
        softWrap: true,
        textAlign: TextAlign.left,
      ),
    );
  }
}
