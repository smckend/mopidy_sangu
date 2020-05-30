import 'package:equatable/equatable.dart';

abstract class UserVoteEvent extends Equatable {
  const UserVoteEvent();
}

class LoadUserVotes extends UserVoteEvent {
  final String sessionId;

  LoadUserVotes({this.sessionId});

  @override
  List<Object> get props => [sessionId];

  @override
  String toString() => "LoadUserVotes { sessionId: $sessionId }";
}

class UpdateUserVotes extends UserVoteEvent {
  final Map<String, dynamic> votes;

  UpdateUserVotes({this.votes});

  @override
  List<Object> get props => [votes];

  @override
  String toString() => "UpdateUserVotes { votes: $votes }";
}

class UserVoteForTrack extends UserVoteEvent {
  final int trackListId;

  UserVoteForTrack({this.trackListId});

  @override
  List<Object> get props => [trackListId];

  @override
  String toString() => "VoteForTrack { trackListId: $trackListId }";
}

class UserUnvoteForTrack extends UserVoteEvent {
  final int trackListId;

  UserUnvoteForTrack({this.trackListId});

  @override
  List<Object> get props => [trackListId];

  @override
  String toString() => "UnvoteForTrack { trackListId: $trackListId }";
}
