import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sangu_websocket/src/models/models.dart';

@immutable
abstract class SanguEvent extends Equatable {
  const SanguEvent();
}

class Seeked extends SanguEvent {
  final int position;

  Seeked({this.position});

  @override
  List<Object> get props => [position];

  @override
  String toString() => "Seek { newPosition: $position }";
}

class ReceivedTrackList extends SanguEvent {
  final List<TlTrack> trackList;

  ReceivedTrackList({this.trackList});

  @override
  List<Object> get props => [trackList];

  @override
  String toString() => "ReceivedTrackList { # tracks: ${trackList.length} }";
}

class TracklistChanged extends SanguEvent {
  @override
  List<Object> get props => [];
}

class WebSocketRetrying extends SanguEvent {
  @override
  List<Object> get props => [];
}

class WebSocketFailed extends SanguEvent {
  final String errorMessage;

  WebSocketFailed({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => "WebSocketFailed { errorMessage: $errorMessage }";
}

class WebSocketClosed extends SanguEvent {
  final int code;
  final String reason;

  WebSocketClosed({this.code, this.reason});

  @override
  List<Object> get props => [code, reason];

  @override
  String toString() => "WebSocketClosed { code: $code, reason: $reason }";
}

class WebSocketConnected extends SanguEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "WebSocketConnected";
}

class ReceivedSearchResults extends SanguEvent {
  final List<SearchResult> searchResults;

  ReceivedSearchResults({this.searchResults});

  @override
  List<Object> get props => [searchResults];

  @override
  String toString() =>
      "ReceivedSearchResults { # searchResults: ${searchResults.length} }";
}

class TrackPlaybackChange extends SanguEvent {
  final String state;

  TrackPlaybackChange({this.state});

  @override
  List<Object> get props => [state];

  @override
  String toString() => "TrackPlaybackChange { state: $state }";
}

class ReceivedAlbumArt extends SanguEvent {
  final Map<String, Images> artwork;

  ReceivedAlbumArt({this.artwork});

  @override
  List<Object> get props => [artwork];

  @override
  String toString() => "ReceivedAlbumArt { # artwork: ${artwork.length} }";
}
