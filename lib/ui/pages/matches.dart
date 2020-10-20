import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/widgets/match_widget.dart';
import 'package:gather_app/ui/widgets/tutorial_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gather_app/bloc/matches/bloc.dart';
import 'package:gather_app/repositories/matchesRepository.dart';

class Matches extends StatefulWidget {
  final String userId;

  Matches({this.userId});

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  MatchesRepository matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;

  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator().getCurrentPosition();

    double location = await Geolocator().distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _matchesBloc = MatchesBloc(matchesRepository: matchesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesBloc, MatchesState>(
      bloc: _matchesBloc,
      builder: (BuildContext context, MatchesState state) {
        if (state is LoadingState) {
          _matchesBloc.add(LoadListsEvent(userId: widget.userId));
          return CircularProgressIndicator();
        }
        if (state is LoadUserState) {
          return Container(
            height: 120,
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    child: Text(
                      "New Matches",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 95,
                    child: Row(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: state.selectedList,
                            builder: (context, snapshot1) {
                              return StreamBuilder(
                                stream: state.matchedList,
                                builder: (context, snapshot2) {
                                  //*
                                  //* IF NEITHER SPNAPSHOTS DONT HAVE DATA
                                  //*
                                  if (!snapshot1.hasData ||
                                      !snapshot2.hasData) {
                                    return Container();
                                  }
                                  //*
                                  //*
                                  //*
                                  if (snapshot1.data.documents != null) {
                                    final selectedUser =
                                        snapshot1.data.documents;
                                    final matchedUser =
                                        snapshot2.data.documents;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: selectedUser.length +
                                                  matchedUser.length !=
                                              0
                                          ? selectedUser.length +
                                              matchedUser.length
                                          : 1,
                                      itemBuilder: (context, index) {
                                        if (index < selectedUser.length) {
                                          return MatchWidget(
                                            index: index,
                                            isRequest: true,
                                            targetUser: selectedUser[index],
                                            currentUserId: widget.userId,
                                            matchesRepository:
                                                matchesRepository,
                                            //*
                                            //* On Accept User Event
                                            //*
                                            onAcceptUserEvent:
                                                (selectedUser, currentUser) {
                                              _matchesBloc.add(
                                                AcceptUserEvent(
                                                  selectedUser:
                                                      selectedUser.uid,
                                                  currentUser: currentUser.uid,
                                                  currentUserPhotoUrl:
                                                      currentUser.photo,
                                                  currentUserName:
                                                      currentUser.name,
                                                  selectedUserPhotoUrl:
                                                      selectedUser.photo,
                                                  selectedUserName:
                                                      selectedUser.name,
                                                ),
                                              );
                                            },
                                            //*
                                            //* On Delete User Event
                                            //*
                                            onDeleteUserEvent:
                                                (selectedUser, currentUser) {
                                              _matchesBloc.add(
                                                DeleteUserEvent(
                                                  currentUser: currentUser.uid,
                                                  selectedUser:
                                                      selectedUser.uid,
                                                ),
                                              );
                                            },
                                          );
                                        } else if (index <
                                            matchedUser.length +
                                                selectedUser.length) {
                                          return MatchWidget(
                                            index:
                                                (index - selectedUser.length),
                                            isRequest: false,
                                            targetUser: matchedUser[
                                                index - selectedUser.length],
                                            currentUserId: widget.userId,
                                            matchesRepository:
                                                matchesRepository,
                                            onOpenChatEvent:
                                                (targetUserId, currentUserId) {
                                              _matchesBloc.add(
                                                OpenChatEvent(
                                                  currentUser: currentUserId,
                                                  selectedUser: targetUserId,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                        return tutorialWidget(1);
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
