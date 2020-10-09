import 'package:equatable/equatable.dart';
import 'package:gather_app/models/user.dart';

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object> get props => [];
}

class InitialAboutState extends AboutState {}

class LoadingState extends AboutState {}

class LoadTargetUserState extends AboutState {
  final User targetUser;
  final String currentUserId;

  LoadTargetUserState(this.targetUser, this.currentUserId);

  @override
  List<Object> get props => [targetUser, currentUserId];
}
