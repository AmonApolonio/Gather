import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_event.dart';
import 'package:gather_app/bloc/blocDelagate.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)
          ..add(AppStarted()),
        child: Home(userRepository: _userRepository),
      ),
    );
  });
}
