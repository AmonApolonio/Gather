import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/profile/bloc.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/widgets/double_text.dart';
import 'package:gather_app/ui/widgets/profileForm.dart';

class Profile extends StatelessWidget {
  final _userRepository;
  final userId;

  Profile({@required UserRepository userRepository, String userId})
      : assert(userRepository != null && userId != null),
        _userRepository = userRepository,
        userId = userId;

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
                      top: size.height * 0.06, bottom: size.height * 0.05),
                  child: DoubleText(
                      text: "Setup Your Profile",
                      subText:
                          "Let’s know a little bit about you. \n This won’t take long"),
                ),
                BlocProvider<ProfileBloc>(
                  create: (context) =>
                      ProfileBloc(userRepository: _userRepository),
                  child: ProfileForm(
                    userRepository: _userRepository,
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
