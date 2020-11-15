import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/client/vote_client.dart';

class VoteBloc extends Bloc<VoteEvent, VoteState> {
  final VoteClient voteClient;

  VoteBloc({@required this.voteClient}) : super(VotesLoading());

  @override
  Stream<VoteState> mapEventToState(
    VoteEvent event,
  ) async* {
    if (event is VoteForTrack) {
      var trackListId = event.trackListId;
      yield* _increaseVotesForTrack(trackListId);
    } else if (event is UnvoteForTrack) {
      var trackListId = event.trackListId;
      yield* _decreaseVotesForTrack(trackListId);
    } else if (event is UpdateVotes) {
      yield* _mapUpdateVotesToState(event);
    }
  }

  Stream<VoteState> _increaseVotesForTrack(int trackListId) async* {
    bool success =
        await voteClient.postVote(trackListId).then((Response result) {
      return result.statusCode == 200;
    });
    if (!success) yield VoteFailed(trackListId: trackListId);
  }

  Stream<VoteState> _decreaseVotesForTrack(int trackListId) async* {
    bool success =
        await voteClient.postUnvote(trackListId).then((Response result) {
      return result.statusCode == 200;
    });
    if (!success) yield UnvoteFailed(trackListId: trackListId);
  }

  Stream<VoteState> _mapUpdateVotesToState(UpdateVotes event) async* {
    Map<String, dynamic> votesResponse = await voteClient.getVoteData();
    yield VotesReady(votes: votesResponse["votes"]);
  }
}
