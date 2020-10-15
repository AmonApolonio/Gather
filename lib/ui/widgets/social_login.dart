import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';

class SocialLogin extends StatelessWidget {
  final VoidCallback onLoginWithFacebook;
  final VoidCallback onLoginWithGoogle;

  const SocialLogin({
    this.onLoginWithFacebook,
    this.onLoginWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "Or connect using",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Clobber',
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                width: 125,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(34, 72, 128, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    right: 10,
                    left: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Icon(
                          GatherCustomIcons.facebook,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(
                        "Facebook",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Clobber',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                onLoginWithFacebook();
              },
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              child: Container(
                width: 125,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 68, 54, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    right: 10,
                    left: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Icon(
                          GatherCustomIcons.google,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(
                        "Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Clobber',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                onLoginWithGoogle();
              },
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
