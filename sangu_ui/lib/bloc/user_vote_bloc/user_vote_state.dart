import 'package:equatable/equatable.dart';

abstract class UserVoteState extends Equatable {
  const UserVoteState();
}

class UserVotesLoading extends UserVoteState {
  @override
  List<Object> get props => [];
}

class UserVotesReady extends UserVoteState {
  final Map<String, dynamic> votes;

  UserVotesReady({this.votes = const {}});

  @override
  List<Object> get props => [votes];
}
