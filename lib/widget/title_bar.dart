import 'package:flutter/material.dart';
import 'package:flutter_weighter/utility/color_utility.dart';

class TitleBar extends StatelessWidget {
  final String label;
  final Function onBackClick;
  final IconData iconData;
  final String titleColor;

  TitleBar(this.label, this.onBackClick, this.iconData, this.titleColor);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(iconData != null ? iconData : Icons.close),
              onPressed: onBackClick != null ? onBackClick : () => Navigator.pop(context),
              color: Color(getColorHexFromStr(titleColor != null ? titleColor : BLACK)),
            ),
            SizedBox(
              width: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.shortestSide * 0.07,
                color: Color(getColorHexFromStr(titleColor != null ? titleColor : BLACK)),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
