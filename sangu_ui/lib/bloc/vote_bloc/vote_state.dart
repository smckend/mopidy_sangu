import 'package:equatable/equatable.dart';

abstract class VoteState extends Equatable {
  const VoteState();
}

class VotesLoading extends VoteState {
  @override
  List<Object> get props => [];
}

class VotesReady extends VoteState {
  final Map<String, int> votes;

  VotesReady({this.votes = const {}});

  @override
  List<Object> get props => [votes];

  @override
  String toString() => "VotesReady { votes: $votes }";
}

class VoteFailed extends VoteState {
  final int trackListId;

  VoteFailed({this.trackListId});

  @override
  List<Object> get props => [trackListId];
}

class UnvoteFailed extends VoteState {
  final int trackListId;

  UnvoteFailed({this.trackListId});

  @override
  List<Object> get props => [trackListId];
}
