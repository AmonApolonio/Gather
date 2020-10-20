import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/about/about_bloc.dart';
import 'package:gather_app/bloc/about/bloc.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/aboutRepository.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/pages/edit_profile.dart';
import 'package:gather_app/ui/widgets/about_card.dart';
import 'package:gather_app/ui/widgets/games_card.dart';
import '../constants.dart';

class AboutTab extends StatefulWidget {
  final String targetUserId, currentUserId;
  final _userRepository;

  const AboutTab(
      {UserRepository userRepository,
      String targetUserId,
      String currentUserId})
      : assert(true),
        _userRepository = userRepository,
        targetUserId = targetUserId,
        currentUserId = currentUserId;

  @override
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  final AboutRepository _aboutRepository = AboutRepository();
  AboutBloc _aboutBloc;
  User _targetUser;
  String _currentUserId;

  @override
  void initState() {
    _aboutBloc = AboutBloc(aboutRepository: _aboutRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<AboutBloc, AboutState>(
      bloc: _aboutBloc,
      builder: (context, state) {
        //*
        //* INITIAL STATE
        //*
        if (state is InitialAboutState) {
          _aboutBloc.add(
            LoadTargetUserEvent(
              currentUserId: widget.currentUserId,
              targetUserId: widget.targetUserId,
            ),
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
        if (state is LoadTargetUserState) {
          _targetUser = state.targetUser;
          _currentUserId = state.currentUserId;
          //*
          //* ABOUT SCREEN
          //*
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            color: backgroundColor,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    //*
                    //* USER PROFILE PHOTO
                    //*
                    Container(
                      height: size.width * 0.55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          _targetUser.photo,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(mainColor),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    //*
                    //* USER NAME AND AGE
                    //*
                    Text(
                      _targetUser.name +
                          "," +
                          (DateTime.now().year - _targetUser.age.toDate().year)
                              .toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    //*
                    //* USER BIO
                    //*
                    //? if the user doesn't have a bio, it will show a standard bio
                    _targetUser.bio.isNotEmpty
                        ? Text(
                            _targetUser.bio,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Clobber',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        : Text(
                            "Just another gamer without a bio",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Clobber',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    //*
                    //* EDIT PROFILE BOTTOM
                    //*
                    //? it only appears if the user shown on the page is the same user logged into the app
                    _currentUserId == _targetUser.uid
                        ? Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        user: state.targetUser,
                                        userRepository: widget._userRepository,
                                      ),
                                    ),
                                  );

                                  if (result) {
                                    _aboutBloc.add(
                                      LoadTargetUserEvent(
                                        currentUserId: widget.currentUserId,
                                        targetUserId: widget.targetUserId,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: size.width - 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Clobber',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                            ],
                          )
                        : Container(),
                    //*
                    //* USER GAMESTYLE, PLATAFORM AND GENDER
                    //*

                    aboutCard(
                      _targetUser.gameplayStyle,
                      _targetUser.plataform,
                      _targetUser.gender,
                      size,
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    //*
                    //* USER GAMES
                    //*
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "GAMES",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Clobber',
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GamesCard(
                      games: _targetUser.games,
                      isEditing: false,
                      onGamesChanged: (games) {},
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
