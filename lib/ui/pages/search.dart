import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/about_screen.dart';
import 'package:gather_app/ui/widgets/premium_dialog.dart';
import 'package:gather_app/ui/widgets/user_card.dart';
import 'package:gather_app/bloc/search/bloc.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/searchRepository.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  final FlareControls animationControls = FlareControls();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        //*
        //* INITIAL STATE
        //*
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return Container(
            color: backgroundColor,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(mainColor),
              ),
            ),
          );
        }
        //*
        //* LOADING STATE
        //*
        if (state is LoadingState) {
          return Container(
            color: backgroundColor,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(mainColor),
              ),
            ),
          );
        }
        //*
        //* LOAD STATE
        //*
        if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;

          if (_user.plataform == null) {
            return Container(
              color: backgroundColor,
              child: Center(
                child: Text(
                  "No one here :(",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Clobber',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          } else
            //*
            //* GATHER SCREEN
            //*
            return Container(
              color: backgroundColor,
              child: Column(
                children: [
                  //*
                  //* USER CARD
                  //*
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutScreen(
                            targetUserId: _user.uid,
                            currentUserId: _currentUser.uid,
                          ),
                        ),
                      );
                    },
                    child: userCard(_user, size),
                  ),

                  Stack(
                    children: [
                      //*
                      //* BUTTONS
                      //*
                      Container(
                        width: size.width,
                        height: size.width * 0.4,
                        child: FlareActor(
                          'assets/animations/Gather_Buttons.flr',
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          controller: animationControls,
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //*
                            //* BACK BUTTON
                            //*
                            GestureDetector(
                              onTap: () async {
                                animationControls.play('back');

                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => premiumDialog(),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: (size.width / 4) - 5,
                                color: Colors.red.withAlpha(0),
                              ),
                            ),
                            //*
                            //* X BUTTON
                            //*
                            GestureDetector(
                              onTap: () async {
                                animationControls.play('cancel');
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    _searchBloc.add(
                                      PassUserEvent(
                                        currentUserId: widget.userId,
                                        selectedUserId: _user.uid,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: (size.width / 4) - 5,
                                color: Colors.red.withAlpha(0),
                              ),
                            ),
                            //*
                            //* STAR BUTTON
                            //*
                            GestureDetector(
                              onTap: () async {
                                animationControls.play('star');
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    _searchBloc.add(
                                      SelectUserEvent(
                                          name: _currentUser.name,
                                          photoUrl: _currentUser.photo,
                                          currentUserId: widget.userId,
                                          selectedUserId: _user.uid),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: (size.width / 4) - 5,
                                color: Colors.red.withAlpha(0),
                              ),
                            ),
                            //*
                            //* PROFILE BUTTON
                            //*
                            GestureDetector(
                              onTap: () async {
                                animationControls.play('forward');
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AboutScreen(
                                          targetUserId: _user.uid,
                                          currentUserId: _currentUser.uid,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: (size.width / 4) - 5,
                                color: Colors.red.withAlpha(0),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
        } else
          return Container();
      },
    );
  }
}
