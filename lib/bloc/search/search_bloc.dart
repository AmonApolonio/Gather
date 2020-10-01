import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/repositories/searchRepository.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository _searchRepository;

  SearchBloc({@required SearchRepository searchRepository})
      : assert(searchRepository != null),
        _searchRepository = searchRepository;

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
        name: event.name,
        photoUrl: event.photoUrl,
      );
    }
    if (event is PassUserEvent) {
      yield* _mapPassToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
      );
    }

    if (event is LoadUserEvent) {
      yield* _mapLoadToState(
        currentUserId: event.userId,
      );
    }
  }

  Stream<SearchState> _mapSelectToState({
    String currentUserId,
    String selectedUserId,
    String name,
    String photoUrl,
  }) async* {
    yield LoadingState();

    User user = await _searchRepository.chooseUser(
        currentUserId, selectedUserId, name, photoUrl);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapPassToState({
    String currentUserId,
    String selectedUserId,
  }) async* {
    yield LoadingState();
    User user = await _searchRepository.passUser(currentUserId, selectedUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapLoadToState({
    String currentUserId,
  }) async* {
    yield LoadingState();
    User user = await _searchRepository.getUser(currentUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }
}
