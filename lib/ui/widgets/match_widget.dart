import 'package:flutter/material.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/matchesRepository.dart';
import 'package:gather_app/ui/pages/about_match.dart';

import '../constants.dart';

typedef void DynamicCallback(dynamic information1, dynamic information2);

class matchWidget extends StatelessWidget {
  final int index;
  final bool isRequest;
  final String currentUserId;
  final targetUser;
  final MatchesRepository matchesRepository;

  final DynamicCallback onDeleteUserEvent;
  final DynamicCallback onAcceptUserEvent;
  final DynamicCallback onOpenChatEvent;

  const matchWidget({
    @required this.index,
    @required this.isRequest,
    @required this.targetUser,
    @required this.matchesRepository,
    @required this.currentUserId,
    this.onAcceptUserEvent,
    this.onDeleteUserEvent,
    this.onOpenChatEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            height: 70,
            width: 70,
            child: Stack(
              alignment: Alignment(0, 0),
              children: <Widget>[
                Container(
                  height: 69,
                  width: 69,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      decoration: isRequest
                          ? BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  mainColor,
                                  Color.fromRGBO(242, 74, 2, 1),
                                  Color.fromRGBO(242, 218, 2, 1),
                                ],
                                tileMode: TileMode.mirror,
                              ),
                            )
                          : BoxDecoration(color: Colors.grey.withAlpha(80)),
                    ),
                  ),
                ),
                Container(
                  height: 65,
                  width: 65,
                  child: CircleAvatar(
                    backgroundColor: backgroundColor,
                  ),
                ),
                Container(
                  height: 61,
                  width: 61,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      targetUser.data['photoUrl'],
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: secondBackgroundColor,
                        );
                      },
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn$index",
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: isRequest
                      ? () async {
                          User selectedUser = await matchesRepository
                              .getUserDetails(targetUser.documentID);
                          User currentUser = await matchesRepository
                              .getUserDetails(currentUserId);

                          final String event = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AboutMatch(
                                currentUserId: currentUserId,
                                targetUserId: targetUser.documentID,
                              ),
                            ),
                          );

                          switch (event) {
                            case "AcceptUserEvent":
                              onAcceptUserEvent(selectedUser, currentUser);
                              break;
                            case "DeleteUserEvent":
                              onDeleteUserEvent(selectedUser, currentUser);
                              break;

                            default:
                          }
                        }
                      : () {
                          onOpenChatEvent(targetUser.documentID, currentUserId);
                        },
                )
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            targetUser.data['name'],
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Clobber',
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
