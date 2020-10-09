import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/constants.dart';

Widget premiumDialog() {
  TextStyle styleMainText = TextStyle(
    color: Colors.white,
    fontFamily: 'Clobber',
    fontSize: 20,
    fontStyle: FontStyle.italic,
  );

  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    clipBehavior: Clip.antiAlias,
    child: Container(
      padding: EdgeInsets.only(left: 7, top: 15),
      height: 145,
      color: mainColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TO USE THIS FEATURE',
            style: styleMainText,
          ),
          Text(
            'YOU MUST HAVE A',
            style: styleMainText,
          ),
          Text(
            'PREMIUM ACCOUNT',
            style: styleMainText,
          ),
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      GatherCustomIcons.gather,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "GO PREMIUM NOW",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
