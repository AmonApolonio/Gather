import 'package:flutter/material.dart';
import 'package:gather_app/ui/constants.dart';

Widget plataformWidget({
  @required icon,
  @required text,
  @required size,
  @required selected,
  @required onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      child: Column(
        children: [
          Container(
            width: size.width * 0.2,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selected == text ? mainColor : secondBackgroundColor),
            child: icon,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              color: selected == text ? mainColor : Colors.white,
              fontFamily: 'Clobber',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
