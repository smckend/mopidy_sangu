import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/artwork_bloc/artwork_bloc.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu/bloc/search_bloc/bloc.dart';
import 'package:sangu/bloc/seek_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/bloc/websocket_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final SW.SanguWebSocket webSocket;
  final VoteBloc voteBloc;

  StreamSubscription _websocketStreamSubscription;
  ArtworkBloc artworkBloc;
  TrackListBloc trackListBloc;
  SeekBloc seekBloc;
  SearchBloc searchBloc;
  PlaybackBloc playbackBloc;

  WebSocketBloc({
    this.webSocket,
    this.voteBloc,
    this.playbackBloc,
    this.seekBloc,
    this.trackListBloc,
    this.artworkBloc,
    this.searchBloc,
  });

  @override
  WebSocketState get initialState => WebSocketLoading();

  @override
  Stream<WebSocketState> mapEventToState(
    WebSocketEvent event,
  ) async* {
    if (event is LoadWebSocket) {
      yield* _mapLoadWebSocketToState(event);
    } else if (event is WebSocketFailed) {
      String reason = event.errorMessage ?? "Could not connect to Mopidy";
      yield FailedToConnect(reason: reason);
    } else if (event is WebSocketClosed) {
      String reason = event.reason ?? "Could not connect to Mopidy";
      yield Disconnected(reason: reason);
    } else if (event is WebSocketRetrying) {
      yield WebSocketLoading();
    } else if (event is WebSocketConnected) {
      yield Connected();
    }
  }

  Stream<WebSocketState> _mapLoadWebSocketToState(LoadWebSocket event) async* {
    _websocketStreamSubscription?.cancel();
    _websocketStreamSubscription = webSocket.stream.listen(
      (event) {
        if (event is SW.WebSocketFailed)
          add(WebSocketFailed(errorMessage: event.errorMessage));
        else if (event is SW.WebSocketClosed) {
          add(WebSocketClosed(
            reason: event.reason,
            code: event.code,
          ));
        } else if (event is SW.WebSocketRetrying)
          add(WebSocketRetrying());
        else if (event is SW.WebSocketConnected)
          add(WebSocketConnected());
        else if (event is SW.ReceivedAlbumArt)
          artworkBloc.add(ReceivedAlbumArt(artwork: event.artwork));
        else if (event is SW.ReceivedTrackList) {
          List<SW.TlTrack> trackList = event.trackList;
          trackListBloc.add(ReceivedTrackList(trackList: event.trackList));
          if (trackList.isNotEmpty)
            artworkBloc.add(
              GetAlbumArt(
                uris: trackList.map((tlTrack) => tlTrack.track.uri).toList(),
              ),
            );
          voteBloc.add(UpdateVotes());
          seekBloc.add(GetTimePosition());
        } else if (event is SW.TrackPlaybackChange)
          playbackBloc.add(TrackPlaybackChange(state: event.state));
        else if (event is SW.ReceivedSearchResults)
          searchBloc
              .add(ReceivedSearchResults(searchResults: event.searchResults));
        else if (event is SW.Seeked)
          seekBloc.add(UpdateSeek(position: event.position));
        else if (event is SW.TrackPlaybackChange)
          playbackBloc.add(TrackPlaybackChange(state: event.state));
        else if (event is SW.TracklistChanged)
          trackListBloc.add(UpdateTrackList());
        else if (event is SW.TrackPlaybackChange)
          trackListBloc.add(UpdateTrackList());
      },
      onError: (error) {
        print("Error event in websocket connection: $error");
      },
    );
  }

  @override
  Future<void> close() {
    _websocketStreamSubscription?.cancel();
    return super.close();
  }
}
