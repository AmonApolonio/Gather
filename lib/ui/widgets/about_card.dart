import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';

import '../constants.dart';

Widget aboutCard(gameplayStyle, plataform, gender, size) {
  double cardWidth = size.width * 0.8;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    alignment: Alignment.center,
    width: cardWidth,
    height: 90,
    decoration: BoxDecoration(
      color: secondBackgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //*
        //* USER GAMESTYLE
        //*
        if (gameplayStyle == "Casual")
          aboutCardItem(
            "CASUAL",
            GatherCustomIcons.casual,
            cardWidth,
          ),
        if (gameplayStyle == "Competitive")
          aboutCardItem(
            "COMPETITIVE",
            GatherCustomIcons.competitive,
            cardWidth,
          ),
        if (gameplayStyle == "")
          aboutCardItem(
            "Unknown",
            GatherCustomIcons.question,
            cardWidth,
          ),
        //*
        //* USER PLATAFORM
        //*
        if (plataform == "PlayStation")
          aboutCardItem(
            "PLAYSTATION",
            GatherCustomIcons.playstation,
            cardWidth,
          ),
        if (plataform == "Xbox")
          aboutCardItem(
            "XBOX",
            GatherCustomIcons.xbox,
            cardWidth,
          ),
        if (plataform == "Computer")
          aboutCardItem(
            "COMPUTER",
            GatherCustomIcons.computer,
            cardWidth,
          ),
        if (plataform == "Mobile")
          aboutCardItem(
            "MOBILE",
            GatherCustomIcons.mobile,
            cardWidth,
          ),
        if (plataform == "")
          aboutCardItem(
            "Unknown",
            GatherCustomIcons.question,
            cardWidth,
          ),
        //*
        //* USER GENDER
        //*
        if (gender == "Male")
          aboutCardItem(
            "MALE",
            GatherCustomIcons.male,
            cardWidth,
          ),
        if (gender == "Female")
          aboutCardItem(
            "FEMALE",
            GatherCustomIcons.female,
            cardWidth,
          ),
        if (gender == "Helicopter")
          aboutCardItem(
            "HELICOPTER",
            GatherCustomIcons.helicopter,
            cardWidth,
          ),
        if (gender == "Other")
          aboutCardItem(
            "OTHER",
            GatherCustomIcons.others,
            cardWidth,
          ),
        if (gender == "")
          aboutCardItem(
            "Unknown",
            GatherCustomIcons.question,
            cardWidth,
          ),
        //*
      ],
    ),
  );
}

Widget aboutCardItem(label, icon, cardWidth) {
  return Container(
    width: (cardWidth - 40) / 3,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: label == "COMPETITIVE"
              ? EdgeInsets.only(right: 15)
              : EdgeInsets.zero,
          padding: label == "COMPETITIVE" ? EdgeInsets.all(3) : EdgeInsets.zero,
          width: (cardWidth - 120) / 3,
          height: 40,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        AutoSizeText(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
          maxLines: 1,
          wrapWords: false,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
