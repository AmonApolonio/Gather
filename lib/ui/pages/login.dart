import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/login/bloc.dart';
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
                Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      bottom: 30,
                      left: size.width * 0.28,
                      right: size.width * 0.28),
                  child: Container(
                    child: Image(
                      image: AssetImage("assets/icons/icon_uso_interno.png"),
                    ),
                  ),
                ),
                DoubleText(
                    text: "Welcome back!",
                    subText: "Log in to your existant Gather’s account"),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
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
