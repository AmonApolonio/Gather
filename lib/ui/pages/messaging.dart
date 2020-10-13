import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/messaging/messaging_event.dart';
import 'package:gather_app/bloc/messaging/messaging_state.dart';
import 'package:gather_app/models/message.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/messagingRepository.dart';
import 'package:gather_app/bloc/messaging/messaging_bloc.dart';
import 'package:gather_app/ui/pages/about_screen.dart';
import 'package:gather_app/ui/widgets/message.dart';
import 'package:gather_app/ui/widgets/photo.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class Messaging extends StatefulWidget {
  final User currentUser, selectedUser;

  Messaging({this.currentUser, this.selectedUser});

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController _messageTextController = TextEditingController();
  MessagingRepository _messagingRepository = MessagingRepository();
  MessagingBloc _messagingBloc;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _messagingBloc = MessagingBloc(messagingRepository: _messagingRepository);

    _messageTextController.text = '';
    _messageTextController.addListener(() {
      setState(() {
        isValid = (_messageTextController.text.isEmpty) ? false : true;
      });
    });
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    print("Message Submitted");

    _messagingBloc.add(
      SendMessageEvent(
        message: Message(
          text: _messageTextController.text,
          senderId: widget.currentUser.uid,
          senderName: widget.currentUser.name,
          selectedUserId: widget.selectedUser.uid,
          photo: null,
        ),
      ),
    );
    _messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: size.height * 0.02,
        title: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                child: Container(
                  height: size.height * 0.06,
                  width: size.height * 0.06,
                  child: PhotoWidget(
                    photoLink: widget.selectedUser.photo,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Expanded(
                child: Text(widget.selectedUser.name),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutScreen(
                  targetUserId: widget.selectedUser.uid,
                  currentUserId: widget.currentUser.uid,
                ),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        bloc: _messagingBloc,
        builder: (BuildContext context, MessagingState state) {
          if (state is MessagingInitialState) {
            _messagingBloc.add(
              MessageStreamEvent(
                  currentUserId: widget.currentUser.uid,
                  selectedUserId: widget.selectedUser.uid),
            );
          }
          if (state is MessagingLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MessagingLoadedState) {
            Stream<QuerySnapshot> messageStream = state.messageStream;
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: messageStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Don't be shy, send something",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Clobber',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      if (snapshot.data.documents.isNotEmpty) {
                        return Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MessageWidget(
                                      currentUserId: widget.currentUser.uid,
                                      messageId: snapshot
                                          .data.documents[index].documentID,
                                    );
                                  },
                                  itemCount: snapshot.data.documents.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Don't be shy, send something",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Clobber',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.09,
                    color: backgroundColor,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            PickedFile result = await _picker.getImage(
                              source: ImageSource.gallery,
                              maxHeight: 700,
                              maxWidth: 700,
                            );

                            File photo = File(result.path);
                            if (photo != null) {
                              _messagingBloc.add(
                                SendMessageEvent(
                                  message: Message(
                                      text: null,
                                      senderName: widget.currentUser.name,
                                      senderId: widget.currentUser.uid,
                                      photo: photo,
                                      selectedUserId: widget.selectedUser.uid),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.01),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: size.height * 0.04,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: size.height * 0.06,
                            padding: EdgeInsets.all(size.height * 0.01),
                            decoration: BoxDecoration(
                              color: secondBackgroundColor,
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.04),
                            ),
                            child: Center(
                              child: TextField(
                                controller: _messageTextController,
                                textInputAction: TextInputAction.send,
                                maxLines: null,
                                decoration: null,
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: mainColor,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Clobber',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: isValid ? _onFormSubmitted : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.01),
                            child: Icon(
                              Icons.send,
                              size: size.height * 0.04,
                              color: isValid ? mainColor : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
