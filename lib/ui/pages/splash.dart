import 'package:flutter/material.dart';
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
            child: Image(
              image: AssetImage("assets/icons/icon_uso_interno.png"),
            ),
          ),
        ),
      ),
    );
  }
}
