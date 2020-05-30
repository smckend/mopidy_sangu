import 'package:equatable/equatable.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

abstract class VoteEvent extends Equatable {
  const VoteEvent();
}

class LoadVoteData extends VoteEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "GetVoteData";
}

class VoteForTrack extends VoteEvent {
  final int trackListId;

  VoteForTrack({this.trackListId});

  @override
  List<Object> get props => [trackListId];

  @override
  String toString() => "VoteForTrack { trackListId: $trackListId }";
}

class UnvoteForTrack extends VoteEvent {
  final int trackListId;

  UnvoteForTrack({this.trackListId});

  @override
  List<Object> get props => [trackListId];

  @override
  String toString() => "UnvoteForTrack { trackListId: $trackListId }";
}

class UpdateVotes extends VoteEvent {
  final List<TlTrack> trackList;

  UpdateVotes({this.trackList});

  @override
  List<Object> get props => [trackList];

  @override
  String toString() => "UpdateVotes { # tracks: ${trackList.length} }";
}
