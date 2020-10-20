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

    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          //*
          //* BUTTONS
          //*
          Container(
            margin: EdgeInsets.only(top: size.height * 0.58),
            width: size.width,
            height: size.width * 0.4,
            child: FlareActor(
              'assets/animations/Gather_Buttons.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              controller: animationControls,
            ),
          ),
          //*
          //* REST OF THE SCREEN THAT CHANGES BASED ON THE STATE
          //*
          BlocBuilder<SearchBloc, SearchState>(
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
                return Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                    top: size.height * 0.04,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: size.width * 0.8,
                      height: size.width * 0.97,
                      color: secondBackgroundColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(mainColor),
                        ),
                      ),
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
                  return Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      top: size.height * 0.04,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: size.width * 0.8,
                        height: size.width * 0.97,
                        color: secondBackgroundColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.55,
                              height: size.width * 0.55,
                              child: FlareActor(
                                'assets/animations/Gather_fire.flr',
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: "Crying",
                              ),
                            ),
                            Text(
                              "No one here",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Clobber',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else
                  //*
                  //* GATHER SCREEN
                  //*
                  return Container(
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
                            Container(
                              width: size.width,
                              height: size.width * 0.4,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
          ),
        ],
      ),
    );
  }
}
