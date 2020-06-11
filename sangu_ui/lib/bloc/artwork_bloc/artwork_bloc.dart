import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class ArtworkBloc extends Bloc<ArtworkEvent, ArtworkState> {
  final SW.SanguWebSocket webSocket;
  LocalStorage _artwork;
  StreamSubscription _storageStreamSubscription;

  ArtworkBloc({this.webSocket});

  @override
  ArtworkState get initialState => AlbumArtLoading();

  @override
  Stream<ArtworkState> mapEventToState(
    ArtworkEvent event,
  ) async* {
    if (event is LoadArtworkEvents)
      yield* _mapLoadArtworkEventsToState(event);
    else if (event is GetAlbumArt)
      yield* _mapGetAlbumArtToState(event);
    else if (event is ReceivedAlbumArt)
      yield* _mapReceivedAlbumArtToState(event);
    else if (event is UpdateAlbumArt) yield* _mapUpdateAlbumArtToState(event);
  }

  Stream<ArtworkState> _mapLoadArtworkEventsToState(
      LoadArtworkEvents event) async* {
    _storageStreamSubscription?.cancel();
    _artwork?.dispose();

    _artwork = LocalStorage('artwork');
    _storageStreamSubscription = _artwork.stream.listen(
      (artwork) => add(
        UpdateAlbumArt(artwork: artwork),
      ),
    );
  }

  Stream<ArtworkState> _mapGetAlbumArtToState(GetAlbumArt event) async* {
    var urisWithNoArtwork = event.uris
        .where((uri) => uri != null && _artwork.getItem(uri) == null)
        .toList();
    if (urisWithNoArtwork.isEmpty) return;
    webSocket.getImages(urisWithNoArtwork);
  }

  Stream<ArtworkState> _mapReceivedAlbumArtToState(
      ReceivedAlbumArt event) async* {
    event.artwork.forEach((String uri, SW.Images images) {
      _artwork.setItem(uri, images);
    });
  }

  Stream<ArtworkState> _mapUpdateAlbumArtToState(UpdateAlbumArt event) async* {
    yield AlbumArtReady(
      artwork: event.artwork.map(
        (String uri, imageJson) => MapEntry<String, SW.Images>(
          uri,
          imageJson != null ? SW.Images.fromJson(imageJson) : null,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _storageStreamSubscription?.cancel();
    _artwork?.dispose();
    return super.close();
  }
}
