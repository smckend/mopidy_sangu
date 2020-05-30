import 'package:equatable/equatable.dart';

abstract class ArtworkState extends Equatable {
  const ArtworkState();
}

class AlbumArtLoading extends ArtworkState {
  @override
  List<Object> get props => [];
}

class AlbumArtReady extends ArtworkState {
  @override
  List<Object> get props => [];
}
