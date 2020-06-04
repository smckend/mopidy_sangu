import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

import 'mopidy_event_stream.dart';
import 'mopidy_rpc_client.dart';

class MopidyWebSocket extends SanguWebSocket {
  Uri webSocketUri;
  MopidyRpcClient _rpcClient;
  MopidyEventMapper _sanguEventStream;
  StreamSubscription _eventStreamSubscription;
  Stream _stream;

  int _reconnectRetryLimit = 5;
  int _reconnectRetryAttempts = 0;

  StreamController<Equatable> _streamController = StreamController.broadcast();

  MopidyWebSocket({@required this.webSocketUri}) {
    _stream = _streamController.stream;
    _initStream();
  }

  void _handleError(dynamic error) {
    print("Rpc client error: $error");
  }

  void _handleClose({int code, String reason}) async {
    if (_reconnectRetryAttempts < _reconnectRetryLimit) {
      print("Retrying websocket connection...");
      _streamController.add(WebSocketRetrying());
      _reconnectRetryAttempts = _reconnectRetryAttempts + 1;
      Future.delayed(const Duration(seconds: 1), () => _initStream());
    } else {
      _streamController
          .add(WebSocketClosed(reason: "Connection closed. Please refresh."));
      print("Retry limit for websocket connection exceeded.");
    }
  }

  Future _initStream() async {
    _eventStreamSubscription?.cancel();
    await _sanguEventStream?.close();
    if (_rpcClient != null && !_rpcClient.isClosed) await _rpcClient?.close();

    print("Starting streams...");
    _rpcClient = MopidyRpcClient(webSocketUri: webSocketUri);
    _sanguEventStream = MopidyEventMapper(webSocketUri: webSocketUri);
    _rpcClient.listen()
      ..catchError((error) {
        _handleError(error);
      })
      ..whenComplete(() async {
        _handleClose(
          code: _rpcClient.closeCode,
          reason: _rpcClient.closeReason,
        );
      });
    _eventStreamSubscription = _sanguEventStream.stream.listen(
      (event) {
        if (event is Equatable) _streamController.add(event);
      },
      cancelOnError: true,
      onError: (error) {
        _handleError(error);
      },
      onDone: () async {
        _handleClose(
          code: _sanguEventStream.closeCode,
          reason: _sanguEventStream.closeReason,
        );
      },
    );
    await Future.delayed(const Duration(milliseconds: 800), () {
      if (!_rpcClient.isClosed) {
        _reconnectRetryAttempts = 0;
        _streamController.add(WebSocketConnected());
      }
    });
  }

  Stream get stream => _stream;

  bool get isConnected => !_streamController.isClosed;

  resumePlayback() async {
    _rpcClient.resume();
  }

  pausePlayback() async {
    _rpcClient.pause();
  }

  playTrack() async {
    _rpcClient.play();
  }

  nextTrack() async {
    _rpcClient.next();
  }

  getCurrentState() async {
    _rpcClient.getState.then((result) {
      String state = result;
      _streamController.add(TrackPlaybackChange(state: state));
    });
  }

  search(Map query) async {
    _rpcClient.search(query: query).then(
      (result) {
        List listResult = result;
        List<SearchResult> searchResults = List();
        listResult.forEach(
          (rawSearchResult) {
            List tracks = rawSearchResult["tracks"];
            String searchBackend = rawSearchResult["uri"].split(":")[0];
            tracks?.forEach(
              (rawTrack) {
                Track track = Track.fromJson(rawTrack);
                searchResults.add(
                    SearchResult(track: track, searchBackend: searchBackend));
              },
            );
          },
        );
        _streamController
            .add(ReceivedSearchResults(searchResults: searchResults ?? []));
      },
    );
  }

  getTrackList() async {
    _rpcClient.getIndex().then(
          (index) => _rpcClient.getSliceOfTlTracks(start: index).then(
            (result) {
              List listOfRawTracks = result;
              var trackList = listOfRawTracks?.map((dynamic rawTrack) {
                return TlTrack.fromJson(rawTrack);
              })?.toList();
              _streamController.add(ReceivedTrackList(trackList: trackList));
            },
          ),
        );
  }

  getImages(List<String> uris) async {
    _rpcClient.getImages(uris).then((result) {
      var artwork = Map<String, Images>();
      (result as Map)?.forEach((uri, images) {
        var imageList = images as List;
        if (imageList.isNotEmpty) {
          artwork[uri] = imageList.length > 1
              ? Images(
                  smallImage:
                      imageList.firstWhere((map) => map["width"] < 200)["uri"],
                  mediumImage: imageList.firstWhere((map) =>
                      200 <= map["width"] && map["width"] <= 400)["uri"],
                  largeImage:
                      imageList.firstWhere((map) => map["width"] > 400)["uri"],
                )
              : Images(
                  smallImage: imageList.first["uri"],
                  mediumImage: imageList.first["uri"],
                  largeImage: imageList.first["uri"]);
        }
      });
      if (artwork.isNotEmpty)
        _streamController.add(ReceivedAlbumArt(artwork: artwork));
    });
  }

  addTrackToTrackList(Track track) async {
    _rpcClient.add([track.uri]).then((result) {
      print("Added '${track.name}' to tracklist");
    });
  }

  removeTrackFromTrackList(TlTrack tlTrack) async {
    _rpcClient.remove([tlTrack.trackListId]).then((result) {
      print("Removed '${tlTrack.track.name}' from tracklist");
    });
  }

  playTrackIfNothingElseIsPlaying() async {
    _rpcClient.getTlTracks.then((result) {
      List listOfRawTracks = result;
      if (listOfRawTracks.length == 1) _rpcClient.play();
    });
  }

  getTimePosition() async {
    _rpcClient.getTimePosition.then((position) {
      _streamController.add(Seeked(position: position));
    });
  }

  void dispose() async {
    _eventStreamSubscription?.cancel();
    _streamController?.close();
    _rpcClient?.close();
    _sanguEventStream?.close();
  }
}
