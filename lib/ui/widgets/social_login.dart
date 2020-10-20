import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';

class SocialLogin extends StatelessWidget {
  final Size size;
  final VoidCallback onLoginWithFacebook;
  final VoidCallback onLoginWithGoogle;

  const SocialLogin({
    @required this.size,
    this.onLoginWithFacebook,
    this.onLoginWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.02,
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
          height: size.height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                width: size.width * 0.35,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(34, 72, 128, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.015,
                    bottom: size.width * 0.015,
                    right: size.width * 0.03,
                    left: size.width * 0.011,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.02),
                        child: Icon(
                          GatherCustomIcons.facebook,
                          color: Colors.white,
                          size: size.width * 0.083,
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
              width: size.width * 0.055,
            ),
            GestureDetector(
              child: Container(
                width: size.width * 0.35,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 68, 54, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.015,
                    bottom: size.width * 0.015,
                    right: size.width * 0.03,
                    left: size.width * 0.011,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.02),
                        child: Icon(
                          GatherCustomIcons.google,
                          color: Colors.white,
                          size: size.width * 0.083,
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
      ],
    );
  }
}
