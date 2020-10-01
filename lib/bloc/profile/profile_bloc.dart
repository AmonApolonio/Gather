import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:gather_app/bloc/profile/profile_event.dart';
import 'package:gather_app/bloc/profile/profile_state.dart';
import 'package:gather_app/repositories/userRepository.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GameplayStyleChanged) {
      yield* _mapGameplayStyleChangedToState(event.gameplayStyle);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
        photo: event.photo,
        name: event.name,
        plataform: event.plataform,
        userId: uid,
        age: event.age,
        location: event.location,
      );
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.uptade(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapAgeChangedToState(DateTime age) async* {
    yield state.uptade(
      isAgeEmpty: age == null,
    );
  }

  Stream<ProfileState> _mapGameplayStyleChangedToState(
      String gameplayStyle) async* {
    yield state.uptade(
      isGameplayStyleEmpty: gameplayStyle == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.uptade(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.uptade(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapSubmittedToState({
    File photo,
    String name,
    String plataform,
    String userId,
    DateTime age,
    GeoPoint location,
  }) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileSetup(
          photo, userId, name, plataform, age, location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
