import 'package:flutter/material.dart';
import 'package:flutter_weighter/utility/color_utility.dart';

class HighlightedValueText extends StatelessWidget {
  final String label;

  HighlightedValueText({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        label,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.shortestSide * 0.1, color: Color(getColorHexFromStr(COLOR_NORMAL))),
        textAlign: TextAlign.center,
      ),
    );
  }
}
