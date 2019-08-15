import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_weighter/model/user.dart';
import 'package:flutter_weighter/redux/app_state.dart';
import 'package:flutter_weighter/screens/home/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/circular_image_card.dart';
import 'package:redux/redux.dart';

class UserProfileRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: HomeBlocProvider.of(context).mainPagerStream,
        builder: (context, snapshot) {
          double scroll = snapshot.hasData ? snapshot.data : 0;

          return Container(
            height: MediaQuery.of(context).size.height * (0.25 + (scroll) * 0.1),
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * (0.125 + (scroll) * 0.05),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height * (0.1 + (scroll) * 0.05),
                      width: MediaQuery.of(context).size.height * (0.1 + (scroll) * 0.05),
                      child: InkWell(
                        onTap: () {
                          HomeBlocProvider.of(context).pageNavigationSink.add(1);
                        },
                        child: CircularImageCard(
                          scale: scroll,
                          image: 'assets/images/icon.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildProfileUserName(context, scroll),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _buildProfileUserName(BuildContext context, double scale) {
    return StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.user,
      builder: (BuildContext context, User user) {
        return Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            UserNameWidget('${user.name}', scale),
            LastUpdatedTextWidget('${AppTranslations.of(context).text("last_updated")} ${user.last_updated}', scale),
          ],
        );
      },
    );
  }
}

class UserNameWidget extends StatelessWidget {
  final String label;
  final double scale;

  UserNameWidget(this.label, this.scale);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.shortestSide * (0.06 + (scale) * 0.01),
          fontWeight: FontWeight.w500),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }
}

class LastUpdatedTextWidget extends StatelessWidget {
  final String label;
  final double scale;

  LastUpdatedTextWidget(this.label, this.scale);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.display1.copyWith(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.shortestSide * (0.03 + (scale) * 0.005),
          fontWeight: FontWeight.w300),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width / 4),
      size.height,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
