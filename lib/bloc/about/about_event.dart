import 'package:equatable/equatable.dart';

abstract class AboutEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTargetUserEvent extends AboutEvent {
  final String currentUserId, targetUserId;

  LoadTargetUserEvent({this.currentUserId, this.targetUserId});

  @override
  List<Object> get props => [currentUserId, targetUserId];
}

class LoadedTargetUserEvent extends AboutEvent {
  final String currentUserId, targetUserId;

  LoadedTargetUserEvent(this.currentUserId, this.targetUserId);

  @override
  List<Object> get props => [currentUserId, targetUserId];
}
