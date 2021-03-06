import 'package:flutter/material.dart';
import 'package:gather_app/ui/widgets/game_card.dart';
import 'package:gather_app/ui/widgets/gameplay_style_card.dart';
import '../constants.dart';

Widget userCard(user, size) {
  return Padding(
    padding: EdgeInsets.only(
      left: size.width * 0.027,
      right: size.width * 0.027,
      top: size.height * 0.04,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: size.width * 0.8,
        height: size.width * 0.97,
        color: secondBackgroundColor,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: size.width * 0.8,
                  height: size.width * 0.7,
                  child: Image.network(
                    user.photo,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(mainColor),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: size.width * 0.03,
                    top: size.width * 0.5,
                  ),
                  width: size.width * 0.8,
                  height: size.width * 0.19,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user.gameplayStyle == "Competitive")
                        gameplayStyleCard(
                          Color.fromRGBO(255, 160, 0, 0.7),
                          'assets/images/competitive.png',
                          "COMPETITIVE",
                          145.0,
                        ),
                      if (user.gameplayStyle == "Casual")
                        gameplayStyleCard(
                          Color.fromRGBO(5, 242, 40, 0.7),
                          'assets/images/casual.png',
                          "CASUAL",
                          100.0,
                        ),
                      if (user.gameplayStyle != "Competitive" &&
                          user.gameplayStyle != "Casual")
                        gameplayStyleCard(
                          Color.fromRGBO(24, 25, 34, 0.7),
                          'assets/images/question_icon.png',
                          "NO STYLE",
                          115.0,
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.name +
                            ", " +
                            (DateTime.now().year - user.age.toDate().year)
                                .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Clobber',
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: size.width * 0.8,
              height: (size.width * 0.8) / 3,
              child: user.games.isNotEmpty
                  ? Row(
                      children: [
                        gameCard(
                            user.games[0].values.toList()[0].toString(), size),
                        if (user.games.length > 1)
                          gameCard(user.games[1].values.toList()[0].toString(),
                              size),
                        if (user.games.length > 2)
                          gameCard(user.games[2].values.toList()[0].toString(),
                              size),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          width: size.width * 0.11,
                          margin: EdgeInsets.only(left: 10, right: 5),
                          child: Image(
                            image: AssetImage("assets/images/brain_icon.png"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(7),
                          width: size.width * 0.8 - 70,
                          child: Text(
                            "This genius created an account but hasn't added any games he plays.",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Clobber',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
