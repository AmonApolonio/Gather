import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/profile/profile_bloc.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/widgets/profileFormComplete.dart';

import '../constants.dart';

class EditProfile extends StatelessWidget {
  final _userRepository;
  final User user;

  EditProfile({UserRepository userRepository, User user})
      : assert(userRepository != null && user != null),
        _userRepository = userRepository,
        user = user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: mainColor,
        leading: Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: Icon(
              GatherCustomIcons.cancel,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(top: 7),
          child: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Clobber',
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(userRepository: _userRepository),
            child: ProfileFormComplete(
              userRepository: _userRepository,
              user: user,
            ),
          ),
        ),
      ),
    );
  }
}
