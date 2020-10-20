import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/login/bloc.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/widgets/double_text.dart';
import 'package:gather_app/ui/widgets/loginForm.dart';

import '../constants.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //*
                //* GATHER ICON
                //*
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.03,
                  ),
                  child: Container(
                    child: Icon(
                      GatherCustomIcons.gather,
                      size: size.height * 0.25,
                      color: mainColor,
                    ),
                  ),
                ),
                //*
                //* WELCOME TEXT
                //*
                DoubleText(
                  text: "Welcome back!",
                  subText: "Log in to your existant Gather’s account",
                ),
                //*
                //* LOGIN FORM
                //*
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.045),
                  child: BlocProvider<LoginBloc>(
                    create: (context) =>
                        LoginBloc(userRepository: _userRepository),
                    child: LoginForm(
                      userRepository: _userRepository,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
