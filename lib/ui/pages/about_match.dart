import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/pages/about_tab.dart';

import '../constants.dart';

class AboutMatch extends StatefulWidget {
  final String targetUserId, currentUserId;

  AboutMatch({this.currentUserId, this.targetUserId});

  @override
  _AboutMatchState createState() => _AboutMatchState();
}

class _AboutMatchState extends State<AboutMatch> {
  final FlareControls animationControls = FlareControls();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondBackgroundColor,
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AboutTab(
                  targetUserId: widget.targetUserId,
                  currentUserId: widget.currentUserId,
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            color: secondBackgroundColor,
            child: Stack(
              children: [
                Container(
                  height: 100,
                  child: FlareActor(
                    'assets/animations/Gather_Just_2_Buttons.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    controller: animationControls,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 120,
                        child: GestureDetector(
                          onTap: () async {
                            animationControls.play('cancel');
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                Navigator.pop(context, "DeleteUserEvent");
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 120,
                        child: GestureDetector(
                          onTap: () async {
                            animationControls.play('star');
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                Navigator.pop(context, "AcceptUserEvent");
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
