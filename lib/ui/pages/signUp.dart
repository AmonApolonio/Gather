import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/signup/bloc.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/widgets/double_text.dart';
import 'package:gather_app/ui/widgets/signUpForm.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print(size.width.toString());
    print(size.height.toString());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //*
              //* INFO TEXT
              //*
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.15,
                  bottom: size.height * 0.045,
                ),
                child: DoubleText(
                    text: "Let’s Get Started!",
                    subText: "Create a Gather’s account to get all features"),
              ),
              //*
              //* SIGN UP FORM
              //*
              BlocProvider<SignUpBloc>(
                create: (context) =>
                    SignUpBloc(userRepository: _userRepository),
                child: SignUpForm(
                  userRepository: _userRepository,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
