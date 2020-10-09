import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/aboutRepository.dart';
import './bloc.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutRepository _aboutRepository;

  AboutBloc({@required AboutRepository aboutRepository})
      : assert(aboutRepository != null),
        _aboutRepository = aboutRepository;

  @override
  AboutState get initialState => InitialAboutState();

  @override
  Stream<AboutState> mapEventToState(
    AboutEvent event,
  ) async* {
    if (event is LoadTargetUserEvent) {
      yield* _mapLoadToState(
        currentUserId: event.currentUserId,
        targetUserId: event.targetUserId,
      );
    }
  }

  Stream<AboutState> _mapLoadToState({
    String currentUserId,
    targetUserId,
  }) async* {
    yield LoadingState();
    User user = await _aboutRepository.getUser(targetUserId);

    yield LoadTargetUserState(user, currentUserId);
  }
}
