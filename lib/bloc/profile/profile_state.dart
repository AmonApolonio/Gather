import 'package:flutter/cupertino.dart';

@immutable
class ProfileState {
  final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isGameplayStyleEmpty;
  final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isFormValid =>
      isPhotoEmpty && isNameEmpty && isAgeEmpty && isGameplayStyleEmpty;

  ProfileState({
    @required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isAgeEmpty,
    @required this.isGameplayStyleEmpty,
    @required this.isLocationEmpty,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory ProfileState.empty() {
    return ProfileState(
      isPhotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGameplayStyleEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false,
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
      isPhotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGameplayStyleEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: true,
      isSuccess: false,
    );
  }

  factory ProfileState.failure() {
    return ProfileState(
      isPhotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGameplayStyleEmpty: false,
      isLocationEmpty: false,
      isFailure: true,
      isSubmitting: false,
      isSuccess: false,
    );
  }

  factory ProfileState.success() {
    return ProfileState(
      isPhotoEmpty: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGameplayStyleEmpty: false,
      isLocationEmpty: false,
      isFailure: false,
      isSubmitting: false,
      isSuccess: true,
    );
  }

  ProfileState uptade({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGameplayStyleEmpty,
    bool isLocationEmpty,
  }) {
    return copyWith(
      isPhotoEmpty: isPhotoEmpty,
      isNameEmpty: isNameEmpty,
      isAgeEmpty: isAgeEmpty,
      isGameplayStyleEmpty: isGameplayStyleEmpty,
      isLocationEmpty: isLocationEmpty,
      isFailure: false,
      isSubmitting: false,
      isSuccess: false,
    );
  }

  ProfileState copyWith({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGameplayStyleEmpty,
    bool isLocationEmpty,
    bool isFailure,
    bool isSubmitting,
    bool isSuccess,
  }) {
    return ProfileState(
      isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,
      isGameplayStyleEmpty: isGameplayStyleEmpty ?? this.isGameplayStyleEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isFailure: isFailure ?? this.isFailure,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
