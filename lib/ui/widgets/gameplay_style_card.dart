import 'package:flutter/material.dart';

Widget gameplayStyleCard(color, icon, label, width) {
  return Container(
    height: 25,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: color,
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 6, right: 5, top: 3, bottom: 4),
          child: Image(
            image: AssetImage(icon),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    ),
  );
}
