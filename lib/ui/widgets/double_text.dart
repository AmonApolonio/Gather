import 'package:flutter/material.dart';

class DoubleText extends StatelessWidget {
  const DoubleText({
    @required this.text,
    @required this.subText,
  });

  final String text;
  final String subText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: size.width * 0.065,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          subText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
