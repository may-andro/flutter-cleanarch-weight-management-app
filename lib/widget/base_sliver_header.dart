import 'package:flutter/material.dart';
import 'package:flutter_weighter/widget/title_bar.dart';

class BaseSliverHeader extends StatelessWidget {
  final Widget bodyWidget;
  final String title;
  final Function onBackClick;
  final IconData iconData;
  final String titleColor;

  BaseSliverHeader({@required this.bodyWidget, @required this.title, this.onBackClick, this.iconData, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: bodyWidget,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.15,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              floating: false,
              iconTheme: IconThemeData(color: Colors.black),
              pinned: false,
              brightness: Brightness.dark,
              automaticallyImplyLeading: false,
              flexibleSpace:
                  FlexibleSpaceBar(collapseMode: CollapseMode.pin, background: TitleBar(title, onBackClick, iconData, titleColor))),
        ];
      },
    );
  }
}
