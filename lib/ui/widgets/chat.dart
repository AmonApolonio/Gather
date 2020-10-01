import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_app/models/chat.dart';
import 'package:gather_app/models/message.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/messageRepository.dart';
import 'package:gather_app/ui/pages/messaging.dart';
import 'package:gather_app/ui/widgets/pageTurn.dart';
import 'package:gather_app/ui/widgets/photo.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatWidget extends StatefulWidget {
  final String userId, selectedUserId;
  final Timestamp creationTime;

  ChatWidget({this.userId, this.selectedUserId, this.creationTime});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  MessageRepository messageRepository = MessageRepository();
  Chat chat;
  User user;

  getUserDetail() async {
    user = await messageRepository.getUserDetail(userId: widget.selectedUserId);

    Message message = await messageRepository
        .getLastMessage(
            currentUserId: widget.userId, selectedUserId: widget.selectedUserId)
        .catchError(
      (error) {
        print(error);
      },
    );

    if (message == null) {
      return Chat(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: null,
        lastMessagePhoto: null,
        timestamp: null,
      );
    } else {
      return Chat(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: message.text,
        lastMessagePhoto: message.photoUrl,
        timestamp: message.timestamp,
      );
    }
  }

  openChat() async {
    User currentUser =
        await messageRepository.getUserDetail(userId: widget.userId);

    User selectedUser =
        await messageRepository.getUserDetail(userId: widget.selectedUserId);

    try {
      pageTurn(
          Messaging(
            currentUser: currentUser,
            selectedUser: selectedUser,
          ),
          context);
    } catch (e) {
      print(e.toString());
    }
  }

  deleteChat() async {
    await messageRepository.deleteChat(
        currentUserId: widget.userId, selectedUserId: widget.selectedUserId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getUserDetail(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          Chat chat = snapshot.data;
          return GestureDetector(
            onTap: () async {
              await openChat();
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Wrap(
                    children: [
                      Text(
                        "Do you want to delete this chat?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "You will not be able to recover this chat",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: size.height * 0.02),
                      ),
                    ],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        await deleteChat();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.02),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * 0.02),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                            child: PhotoWidget(
                              photoLink: user.photo,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(fontSize: size.height * 0.035),
                            ),
                            chat.lastMessage != null
                                ? Text(
                                    chat.lastMessage,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : chat.lastMessagePhoto == null
                                    ? Text(
                                        "Chat Room available",
                                        style: TextStyle(
                                            fontSize: size.height * 0.02),
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.photo,
                                              color: Colors.grey,
                                              size: size.height * 0.02),
                                          Text(
                                            " Photo",
                                            style: TextStyle(
                                                fontSize: size.height * 0.015,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                          ],
                        ),
                      ],
                    ),
                    chat.timestamp != null
                        ? Text(timeago.format(chat.timestamp.toDate()))
                        : Text(timeago.format(widget.creationTime.toDate())),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
