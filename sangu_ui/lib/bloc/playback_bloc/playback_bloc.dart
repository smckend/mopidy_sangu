import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class PlaybackBloc extends Bloc<PlaybackEvent, String> {
  SW.SanguWebSocket webSocket;
  final _knownStates = [
    SW.TrackPlayingState,
    SW.TrackPausedState,
    SW.TrackStoppedState
  ];

  PlaybackBloc({this.webSocket});

  @override
  String get initialState => SW.TrackStoppedState;

  @override
  Stream<String> mapEventToState(
    PlaybackEvent event,
  ) async* {
    if (event is PlayTrack)
      webSocket.playTrack();
    else if (event is ResumeTrack)
      webSocket.resumePlayback();
    else if (event is PauseTrack)
      webSocket.pausePlayback();
    else if (event is SkipTrack)
      webSocket.nextTrack();
    else if (event is TrackPlaybackChange) {
      String newState = event.state;
      if (_knownStates.contains(newState)) yield newState;
    } else if (event is GetCurrentState) webSocket.getCurrentState();
  }
}
