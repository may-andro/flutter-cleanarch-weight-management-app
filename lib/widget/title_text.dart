import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String label;
  final bool isCenter;

  TitleText({@required this.label, this.isCenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isCenter ? Alignment.center : Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.055),
      ),
    );
  }
}
