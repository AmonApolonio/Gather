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
        child: Icon(
          GatherCustomIcons.gather,
          size: size.width * 0.7,
          color: mainColor,
        ),
      ),
    );
  }
}
