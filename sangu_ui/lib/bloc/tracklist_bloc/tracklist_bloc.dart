import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class TrackListBloc extends Bloc<TrackListEvent, TrackListState> {
  SW.SanguWebSocket webSocket;
  StreamSubscription _streamSubscription;
  SW.TlTrack currentTrack;

  TrackListBloc({this.webSocket});

  @override
  TrackListState get initialState => TrackListLoading();

  @override
  Stream<TrackListState> mapEventToState(
    TrackListEvent event,
  ) async* {
    if (event is LoadTracklistEvents) {
      yield* _mapLoadTracklistEventsToState(event);
    } else if (event is ReceivedTrackList) {
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

  Stream<TrackListState> _mapLoadTracklistEventsToState(
      LoadTracklistEvents event) async* {
    _streamSubscription?.cancel();
    _streamSubscription = webSocket.stream.listen(
      (event) {
        if (event is SW.ReceivedTrackList) {
          add(ReceivedTrackList(trackList: event.trackList));
        } else if (event is SW.TracklistChanged) {
          add(UpdateTrackList());
        } else if (event is SW.TrackPlaybackChange) {
          add(UpdateTrackList());
        }
      },
    );
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

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
