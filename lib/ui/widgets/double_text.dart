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
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          subText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
