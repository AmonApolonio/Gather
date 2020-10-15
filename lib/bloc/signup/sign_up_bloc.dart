import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/validators.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  UserRepository _userRepository;

  SignUpBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transformEvents(
    Stream<SignUpEvent> events,
    Stream<SignUpState> Function(SignUpEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email, password: event.password);
    } else if (event is SignUpWithGoogle) {
      yield* _mapLoginWithGoogle();
    } else if (event is SignUpWithFacebook) {
      yield* _mapLoginWithFacebook(result: event.result);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.uptade(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.uptade(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signUpWithEmail(email, password);

      yield SignUpState.success();
    } catch (_) {
      SignUpState.failure();
    }
  }

  Stream<SignUpState> _mapLoginWithGoogle() async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signInWithGoogle();

      yield SignUpState.success();
    } catch (_) {
      yield SignUpState.failure();
    }
  }

  Stream<SignUpState> _mapLoginWithFacebook({String result}) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signInWithFacebook(result);

      yield SignUpState.success();
    } catch (_) {
      yield SignUpState.failure();
    }
  }
}
