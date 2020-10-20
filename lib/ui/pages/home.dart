import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/authentication/bloc.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/login.dart';
import 'package:gather_app/ui/pages/profile_setup.dart';
import 'package:gather_app/ui/pages/splash.dart';
import 'package:gather_app/ui/widgets/tabs.dart';

class Home extends StatelessWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gather",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        accentColor: mainColor,
        textSelectionColor: Colors.grey[300],
        cursorColor: mainColor,
        textSelectionHandleColor: mainColor,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return Splash();
          }
          if (state is Authenticated) {
            return Tabs(
              userRepository: _userRepository,
              userId: state.userId,
            );
          }
          if (state is AuthenticatedButNotSet) {
            return ProfileSetup(
              userRepository: _userRepository,
              userId: state.userId,
            );
          }
          if (state is Unauthenticated) {
            return Login(
              userRepository: _userRepository,
            );
          } else
            return Container();
        },
      ),
    );
  }
}
