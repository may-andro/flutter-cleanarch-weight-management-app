import 'package:flutter/material.dart';
import 'package:flutter_weighter/utility/color_utility.dart';

class BorderedContainer extends StatelessWidget {
  final Widget child;
  final String label;

  BorderedContainer({@required this.child, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.shortestSide * 0.02),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.025),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.shortestSide * 0.1))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.shortestSide * 0.05),
                child: Align(alignment: Alignment.bottomCenter, child: child),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.shortestSide * 0.1,
            child: Container(
                decoration: BoxDecoration(
                    color: Color(getColorHexFromStr(COLOR_BACKGROUND)),
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.shortestSide * 0.1))),
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(label, style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.03, fontWeight: FontWeight.w500, color: Colors.black54,)),
                )),
          )
        ],
      ),
    );
  }
}
