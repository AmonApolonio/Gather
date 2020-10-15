import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/constants.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
              top: 20,
              bottom: 30,
              left: size.width * 0.28,
              right: size.width * 0.28),
          child: Container(
            child: Icon(
              GatherCustomIcons.gather,
              size: 250,
              color: mainColor,
            ),
          ),
        ),
      ),
    );
  }
}
