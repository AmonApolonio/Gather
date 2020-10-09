import 'package:flutter/material.dart';

Widget eloCard(elo, size) {
  String label;

  switch (elo) {
    case "LOW":
      label = "Low elo";
      break;
    case "AVERAGE":
      label = "Average";
      break;
    case "HIGH":
      label = "High elo";
      break;
    case "PRO":
      label = "Pro player";
      break;
    default:
  }

  return Container(
    padding: EdgeInsets.all(20),
    width: (size.width - 80) / 2,
    height: 150,
    child: Column(
      children: [
        Container(
          height: 70,
          child: Image.asset(
            "assets/icons/$elo.png",
          ),
          width: 100,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}
