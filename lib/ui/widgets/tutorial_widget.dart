import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';

import '../constants.dart';

Widget tutorialWidget(index) {
  return Container(
    margin: EdgeInsets.all(5),
    child: Column(
      children: <Widget>[
        Container(
          height: 70,
          width: 70,
          child: Stack(
            alignment: Alignment(0, 0),
            children: <Widget>[
              Container(
                height: 69,
                width: 69,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(80),
                    ),
                  ),
                ),
              ),
              Container(
                height: 65,
                width: 65,
                child: CircleAvatar(
                  backgroundColor: backgroundColor,
                ),
              ),
              Container(
                height: 61,
                width: 61,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Icon(
                    GatherCustomIcons.gather,
                    color: mainColor,
                    size: 40,
                  ),
                ),
              ),
              FloatingActionButton(
                heroTag: "btn$index",
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {},
              )
            ],
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          "Gather Tutorial",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}
