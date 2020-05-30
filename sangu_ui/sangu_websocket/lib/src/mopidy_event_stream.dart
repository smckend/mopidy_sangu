import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sangu_websocket/sangu_websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MopidyEventMapper {
  WebSocketChannel _eventChannel;

  MopidyEventMapper({@required Uri webSocketUri}) {
    _eventChannel = WebSocketChannel.connect(webSocketUri);
    _startPing();
  }

  close() async => await _eventChannel.sink.close();

  int get closeCode => _eventChannel.closeCode;

  String get closeReason => _eventChannel.closeReason;

  Stream get stream => _eventChannel.stream.transform(_handleEventTransformer);

  Future _startPing() async {
    while (_eventChannel.closeCode == null) {
      _eventChannel.sink.add("{\"jsonrpc\":\"2.0\",\"method\":\"ping\"}");
      await Future.delayed(const Duration(seconds: 30), () => "wake");
    }
  }

  final StreamTransformer _handleEventTransformer =
      StreamTransformer<dynamic, dynamic>.fromHandlers(
          handleData: (data, sink) {
    dynamic eventJson = jsonDecode(data);
    switch (eventJson["event"]) {
      case "playback_state_changed":
        String newState = eventJson["new_state"];
        String oldState = eventJson["old_state"];
        if (newState != oldState)
          sink.add(TrackPlaybackChange(state: newState));
        break;

      case "volume_changed":
        break;

      case "track_playback_started":
        sink.add(TrackPlaybackChange(state: TrackPlayingState));
        break;

      case "track_playback_resumed":
        sink.add(TrackPlaybackChange(state: TrackPlayingState));
        break;

      case "track_playback_paused":
        sink.add(TrackPlaybackChange(state: TrackPausedState));
        break;

      case "track_playback_ended":
        break;

      case "tracklist_changed":
        sink.add(TracklistChanged());
        break;

      case "seeked":
        int timePosition = eventJson["time_position"];
        sink.add(Seeked(position: timePosition));
        break;
    }
  });
}
