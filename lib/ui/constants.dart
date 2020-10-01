import 'package:flutter/material.dart';

const backgroundColor = Color.fromRGBO(24, 25, 34, 1);
const secondBackgroundColor = Color.fromRGBO(39, 42, 55, 1);
const mainColor = Color.fromRGBO(242, 117, 2, 1);

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
