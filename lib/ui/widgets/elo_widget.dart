import 'package:flutter/material.dart';

import '../constants.dart';

Widget buildEloWidget(String skill, bool canEdit) {
  TextStyle _style = TextStyle(
    color: secondBackgroundColor,
    fontFamily: 'Clobber',
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  String mainIcon;
  String name;

  switch (skill) {
    case "LOW":
      mainIcon = "low_elo";
      name = "LOW-ELO";
      break;
    case "AVERAGE":
      mainIcon = "mid_elo";
      name = "AVERAGE-ELO";
      break;
    case "HIGH":
      mainIcon = "high_elo";
      name = "HIGH-ELO";
      break;
    case "PRO":
      mainIcon = "pro_player";
      name = "PRO-PLAYER";
      break;
    default:
  }

  return skill.isNotEmpty
      ? Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 4),
                width: 28,
                height: 18,
                child: Image(
                  image: AssetImage('assets/icons/$mainIcon.png'),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  name,
                  style: _style,
                ),
              ),
            ],
          ),
        )
      : Container(
          margin: EdgeInsets.only(top: 12),
          child: Text(
            "ADD SKIL LEVEL",
            style: _style,
          ),
        );
}
