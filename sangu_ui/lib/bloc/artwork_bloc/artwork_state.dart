import 'package:equatable/equatable.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

abstract class ArtworkState extends Equatable {
  const ArtworkState();
}

class AlbumArtLoading extends ArtworkState {
  @override
  List<Object> get props => [];
}

class AlbumArtReady extends ArtworkState {
  final Map<String, Images> artwork;

  AlbumArtReady({this.artwork});

  @override
  List<Object> get props => [artwork];

  @override
  String toString() {
    return "AlbumArtReady { artwork #: ${artwork.length} }";
  }
}
