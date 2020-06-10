import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class TrackListBloc extends Bloc<TrackListEvent, TrackListState> {
  SW.SanguWebSocket webSocket;

  TrackListBloc({this.webSocket});

  @override
  TrackListState get initialState => TrackListLoading();

  @override
  Stream<TrackListState> mapEventToState(
    TrackListEvent event,
  ) async* {
    if (event is ReceivedTrackList) {
      yield* _mapReceivedTrackListToState(event);
    } else if (event is UpdateTrackList) {
      webSocket.getTrackList();
    } else if (event is AddTrack) {
      await webSocket.addTrackToTrackList(event.track);
      webSocket.playTrackIfNothingElseIsPlaying();
    } else if (event is RemoveTrack) {
      await webSocket.removeTrackFromTrackList(event.tlTrack);
    }
  }

  Stream<TrackListState> _mapReceivedTrackListToState(
      ReceivedTrackList event) async* {
    List<SW.TlTrack> newTrackList = event.trackList;
    if (newTrackList.isNotEmpty) {
      SW.TlTrack currentTrack = newTrackList.first;
      newTrackList.removeAt(0);
      yield TrackListReady(
        currentTrack: currentTrack,
        trackList: newTrackList,
      );
    } else {
      yield TrackListReady();
    }
  }
}
