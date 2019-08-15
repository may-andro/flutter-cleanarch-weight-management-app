import 'package:flutter/material.dart';
import 'bordered_container.dart';

class EditableSelectionWidget extends StatelessWidget {
  final String label;
  final String value;
  final Function onPress;
  final IconData iconData;

  EditableSelectionWidget({this.label, this.value, this.onPress, this.iconData});

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: ValueWidget(
        label: value,
        onPress: onPress,
        iconData: iconData,
      ),
      label: label,
    );
  }
}

class ValueWidget extends StatelessWidget {
  final String label;
  final Function onPress;
  final IconData iconData;

  ValueWidget({@required this.label, @required this.onPress, this.iconData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
            ),
            iconData != null
                ? Icon(
                    iconData,
                    color: Colors.black87,
                    size: MediaQuery.of(context).size.shortestSide * 0.04,
                  )
                : Offstage()
          ],
        ),
      ),
    );
  }
}
