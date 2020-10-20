import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/message/bloc.dart';
import 'package:gather_app/repositories/messageRepository.dart';
import 'package:gather_app/ui/widgets/chat.dart';

class Messages extends StatefulWidget {
  final String userId;

  Messages({this.userId});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessageRepository _messageRepository = MessageRepository();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(messageRepository: _messageRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {
          _messageBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        }
        if (state is ChatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Loading...",
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatWidget(
                        creationTime:
                            snapshot.data.documents[index].data['timestamp'],
                        userId: widget.userId,
                        selectedUserId:
                            snapshot.data.documents[index].documentID,
                      );
                    },
                  );
                }
              } else
                return Column(
                  children: [
                    Container(
                      width: size.width * 0.55,
                      height: size.width * 0.55,
                      child: FlareActor(
                        'assets/animations/Gather_fire.flr',
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Looking Around",
                      ),
                    ),
                    FutureBuilder(
                      future: Future.delayed(
                        Duration(seconds: 5),
                        () {
                          return 20.0;
                        },
                      ),
                      initialData: 0.0,
                      builder: (BuildContext context,
                          AsyncSnapshot<double> fontSize) {
                        return Text(
                          "You don't have any friends",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Clobber',
                            fontSize: fontSize.data,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    )
                  ],
                );
            },
          );
        }
        return Container();
      },
    );
  }
}
