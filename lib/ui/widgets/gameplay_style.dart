import 'package:flutter/material.dart';
import 'package:gather_app/ui/constants.dart';

Widget gameplayStyleWidget({
  @required icon,
  @required text,
  @required size,
  @required selected,
  onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 5, vertical: size.height * 0.02),
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: selected == text ? mainColor : Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 50,
              margin: EdgeInsets.all(1),
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Icon(
                  icon,
                  color: selected == text ? mainColor : Colors.white,
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: selected == text ? mainColor : Colors.white,
                fontFamily: 'Clobber',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
