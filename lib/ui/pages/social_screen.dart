import 'package:flutter/material.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/matches.dart';
import 'package:gather_app/ui/pages/messages.dart';

class Social extends StatelessWidget {
  final String userId;

  Social({this.userId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: secondBackgroundColor,
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          Container(
            height: 120,
            color: backgroundColor,
            child: Matches(
              userId: userId,
            ),
          ),
          Expanded(
            child: Messages(
              userId: userId,
            ),
          ),
        ],
      ),
    );
  }
}
