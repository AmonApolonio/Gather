import 'package:flutter/material.dart';
import 'package:gather_app/models/message.dart';
import 'package:gather_app/repositories/messagingRepository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/widgets/photo.dart';

class MessageWidget extends StatefulWidget {
  final String messageId, currentUserId;

  const MessageWidget({this.messageId, this.currentUserId});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepository _messagingRepository = MessagingRepository();
  Message _message;

  Future getDetails() async {
    _message = await _messagingRepository.getMessageDetail(
        messageId: widget.messageId);

    return _message;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          _message = snapshot.data;
          return Column(
            crossAxisAlignment: _message.senderId == widget.currentUserId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              _message.text != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        _message.senderId == widget.currentUserId
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.025),
                                child: Text(
                                  timeago.format(
                                    _message.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Clobber',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.7),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _message.senderId == widget.currentUserId
                                    ? mainColor
                                    : Colors.white,
                                borderRadius: _message.senderId ==
                                        widget.currentUserId
                                    ? BorderRadius.only(
                                        topLeft:
                                            Radius.circular(size.height * 0.02),
                                        topRight:
                                            Radius.circular(size.height * 0.02),
                                        bottomLeft:
                                            Radius.circular(size.height * 0.02),
                                      )
                                    : BorderRadius.only(
                                        topLeft:
                                            Radius.circular(size.height * 0.02),
                                        topRight:
                                            Radius.circular(size.height * 0.02),
                                        bottomRight:
                                            Radius.circular(size.height * 0.02),
                                      ),
                              ),
                              padding: EdgeInsets.all(size.height * 0.012),
                              child: Text(
                                _message.text,
                                style: TextStyle(
                                  color:
                                      _message.senderId == widget.currentUserId
                                          ? Colors.white
                                          : backgroundColor,
                                  fontFamily: 'Clobber',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _message.senderId == widget.currentUserId
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.025),
                                child: Text(
                                  timeago.format(
                                    _message.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Clobber',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                      ],
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        _message.senderId == widget.currentUserId
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.025),
                                child: Text(
                                  timeago.format(
                                    _message.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Clobber',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: size.width * 0.7,
                                maxHeight: size.width * 0.8),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: backgroundColor),
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.02),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.02),
                                child: PhotoWidget(
                                  photoLink: _message.photoUrl,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _message.senderId == widget.currentUserId
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.025),
                                child: Text(
                                  timeago.format(
                                    _message.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Clobber',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              )
                      ],
                    ),
            ],
          );
        }
      },
    );
  }
}
