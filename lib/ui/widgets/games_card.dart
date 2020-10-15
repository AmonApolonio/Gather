import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gather_app/ui/widgets/elo_dialog.dart';
import 'package:gather_app/ui/widgets/elo_widget.dart';
import 'package:gather_app/ui/widgets/game_dialog.dart';

import '../constants.dart';

typedef void DynamicCallback(dynamic gamesUptade);

class GamesCard extends StatefulWidget {
  final List<dynamic> games;
  final bool isEditing;
  final DynamicCallback onGamesChanged;

  GamesCard({
    @required this.games,
    @required this.isEditing,
    this.onGamesChanged,
  });

  @override
  _GamesCardState createState() => _GamesCardState();
}

class _GamesCardState extends State<GamesCard> {
  bool isDeleteEnable, isAddGameEnable;
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return widget.games.isNotEmpty
        ? Theme(
            data: ThemeData(
              highlightColor: mainColor,
            ),
            child: Container(
              height: 182,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: secondBackgroundColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.games.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        //*
                        //* BUILD GAME WIDGET
                        //*
                        return index < widget.games.length
                            ? Stack(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(231, 231, 231, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(7),
                                      margin: EdgeInsets.only(
                                          top: 7, bottom: 15, left: 7),
                                      width: 130,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              child: Image.network(
                                                'https://firebasestorage.googleapis.com/v0/b/gather-81171.appspot.com/o/games%2F' +
                                                    widget.games[index].values
                                                        .toList()[0]
                                                        .toString() +
                                                    '%2F' +
                                                    widget.games[index].values
                                                        .toList()[0]
                                                        .toString() +
                                                    '.png?alt=media&token=10840b42-3dad-4924-a43d-7d65fe9e0050',
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              mainColor),
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          buildEloWidget(
                                              widget.games[index].values
                                                  .toList()[1]
                                                  .toString(),
                                              widget.isEditing),
                                        ],
                                      ),
                                    ),
                                    //*
                                    //* ENABLE ON TAP IF IS EDITING IS ENABLE
                                    //*
                                    onTap: widget.isEditing
                                        ? () {
                                            isDeleteEnable
                                                ? setState(() {
                                                    isDeleteEnable = false;
                                                  })
                                                : showDialog(
                                                    context: context,
                                                    builder: (_) => EloDialog(
                                                      onEloChanged: (elo) {
                                                        print(
                                                          widget.games[index]
                                                              .values
                                                              .toList()[0]
                                                              .toString(),
                                                        );
                                                        Map<String, String>
                                                            game = {
                                                          "game": widget
                                                              .games[index]
                                                              .values
                                                              .toList()[0]
                                                              .toString(),
                                                          "skill": elo,
                                                        };
                                                        widget.games[index] =
                                                            game;
                                                        widget.onGamesChanged(
                                                            widget.games);
                                                      },
                                                    ),
                                                  );
                                          }
                                        : () {},
                                    //*
                                    //* ENABLE ON LONG PRESS IF IS EDITING IS ENABLE
                                    //*
                                    onLongPress: widget.isEditing
                                        ? () {
                                            HapticFeedback.vibrate();
                                            setState(() {
                                              isDeleteEnable = true;
                                            });
                                          }
                                        : () {},
                                  ),
                                  //*
                                  //* ENABLE DELETE BUTTON IF IS DELETING IS ENABLE
                                  //*
                                  isDeleteEnable == true
                                      ? Positioned(
                                          left: 100,
                                          child: GestureDetector(
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: secondBackgroundColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.cancel,
                                                color: Color.fromRGBO(
                                                    231, 231, 231, 1),
                                                size: 25,
                                              ),
                                            ),
                                            onTap: () {
                                              widget.games.removeAt(index);
                                              widget
                                                  .onGamesChanged(widget.games);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            //*
                            //* BUILD ADD GAME WIDGET
                            //*
                            : widget.isEditing
                                ? GestureDetector(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 7),
                                      width: 150,
                                      height: 50,
                                      child: Container(
                                        color: isAddGameEnable != false
                                            ? mainColor
                                            : secondBackgroundColor,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              "Add Game",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Clobber',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //*
                                    //* OPEN A "DIALOG" WHEN YOU TAP ON THE "ADD GAME" BUTTON
                                    //*
                                    onTap: () async {
                                      setState(() {
                                        isAddGameEnable = false;
                                      });

                                      List<String> gameList = [];

                                      await _firestore
                                          .collection('games')
                                          .getDocuments()
                                          .then(
                                        (games) {
                                          for (var game in games.documents) {
                                            gameList.add(game.data['name']);
                                          }
                                        },
                                      );

                                      final String gameName =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => GameDialog(
                                            gameList: gameList,
                                          ),
                                        ),
                                      );

                                      setState(() {
                                        isAddGameEnable = true;
                                      });

                                      if (gameName != null) {
                                        final Map<String, String> game = {
                                          "game": gameName,
                                          "skill": ""
                                        };
                                        widget.games.add(game);
                                        widget.onGamesChanged(widget.games);
                                      }
                                    },
                                  )
                                : Container(
                                    width: 7,
                                  );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: secondBackgroundColor,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Image(
                    image: AssetImage("assets/images/brain_icon.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  width: 200,
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
          );
  }
}
