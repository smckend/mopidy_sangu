import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sangu/bloc/user_vote_bloc/bloc.dart';

class UserVoteBloc extends Bloc<UserVoteEvent, UserVoteState> {
  String _sessionId;
  LocalStorage _userVotes;
  StreamSubscription _userVotesSubscription;

  UserVoteBloc() : super(UserVotesLoading());

  @override
  Stream<UserVoteState> mapEventToState(
    UserVoteEvent event,
  ) async* {
    if (event is LoadUserVotes) {
      yield* _mapLoadUserVotesToState(event);
    } else if (event is UserVoteForTrack) {
      var trackListId = event.trackListId;
      yield* _voteForTrack(trackListId);
    } else if (event is UserUnvoteForTrack) {
      var trackListId = event.trackListId;
      yield* _unVoteForTrack(trackListId);
    } else if (event is UpdateUserVotes) {
      yield* _mapUpdateUserVotesToState(event);
    }
  }

  Stream<UserVoteState> _mapLoadUserVotesToState(LoadUserVotes event) async* {
    _userVotesSubscription?.cancel();
    _userVotes?.dispose();

    _sessionId = event.sessionId;
    _userVotes = LocalStorage("votes-$_sessionId");
    _userVotesSubscription = _userVotes.stream
        .listen((userVotes) => add(UpdateUserVotes(votes: userVotes)));
  }

  Stream<UserVoteState> _voteForTrack(int trackListId) async* {
    String key = trackListId.toString();
    if (_userVotes.getItem(key) == null) _userVotes.setItem(key, 1);
  }

  Stream<UserVoteState> _unVoteForTrack(int trackListId) async* {
    String key = trackListId.toString();
    if (_userVotes.getItem(key) != null) _userVotes.deleteItem(key);
  }

  Stream<UserVoteState> _mapUpdateUserVotesToState(
      UpdateUserVotes event) async* {
    yield UserVotesReady(votes: event.votes);
  }

  @override
  Future<void> close() {
    _userVotes.dispose();
    _userVotesSubscription?.cancel();
    return super.close();
  }
}
