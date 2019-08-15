import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String label;
  DescriptionText({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        label,
        style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
      ),
    );
  }
}
