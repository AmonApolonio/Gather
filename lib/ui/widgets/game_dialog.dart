import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/constants.dart';

class GameDialog extends StatelessWidget {
  final List<String> gameList;

  GameDialog({@required this.gameList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      //*
      //* APP BAR
      //*
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: GestureDetector(
          child: Icon(
            GatherCustomIcons.cancel,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          padding: EdgeInsets.only(top: 7),
          child: Text(
            "Select a game",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Clobber',
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              gameList.length,
              (index) {
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/gather-81171.appspot.com/o/games%2F' +
                            gameList[index] +
                            '%2F' +
                            gameList[index] +
                            '.png?alt=media&token=10840b42-3dad-4924-a43d-7d65fe9e0050',
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
                  ),
                  onTap: () {
                    Navigator.pop(context, gameList[index]);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
