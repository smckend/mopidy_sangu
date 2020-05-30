import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

@immutable
abstract class ArtworkEvent extends Equatable {
  const ArtworkEvent();
}

class LoadArtworkEvents extends ArtworkEvent {
  @override
  List<Object> get props => [];
}

class GetAlbumArt extends ArtworkEvent {
  final List<String> uris;

  GetAlbumArt({this.uris});

  @override
  List<Object> get props => [uris];

  @override
  String toString() => "GetAlbumArt { # urs: ${uris.length}}";
}

class ReceivedAlbumArt extends ArtworkEvent {
  final Map<String, Images> artwork;

  ReceivedAlbumArt({this.artwork});

  @override
  List<Object> get props => [artwork];

  @override
  String toString() => "ReceivedAlbumArt { # artwork: ${artwork.length} }";
}
