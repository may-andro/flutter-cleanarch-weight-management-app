import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double height;

  VerticalSpacer({@required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
