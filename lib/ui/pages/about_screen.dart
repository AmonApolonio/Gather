import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/about_tab.dart';

class AboutScreen extends StatelessWidget {
  final FlareControls animationControls = FlareControls();
  final String targetUserId, currentUserId;

  AboutScreen({this.targetUserId, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 50,
          elevation: 0,
          backgroundColor: mainColor,
          leading: Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: Icon(
                GatherCustomIcons.cancel,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Container(
            padding: EdgeInsets.only(top: 7),
            child: Text(
              "About",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Clobber',
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: AboutTab(
          targetUserId: targetUserId,
          currentUserId: currentUserId,
        ),
      ),
    );
  }
}
