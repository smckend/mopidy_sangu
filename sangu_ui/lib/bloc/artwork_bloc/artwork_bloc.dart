import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class ArtworkBloc extends Bloc<ArtworkEvent, ArtworkState> {
  final SW.SanguWebSocket webSocket;
  LocalStorage _artwork;
  StreamSubscription _streamSubscription;

  ArtworkBloc({this.webSocket});

  @override
  ArtworkState get initialState => AlbumArtLoading();

  @override
  Stream<ArtworkState> mapEventToState(
    ArtworkEvent event,
  ) async* {
    if (event is LoadArtworkEvents) {
      yield* _mapLoadArtworkEventsToState(event);
    } else if (event is ReceivedAlbumArt) {
      yield* _mapReceivedAlbumArtToState(event);
    } else if (event is GetAlbumArt) {
      yield* _mapGetAlbumArtToState(event);
    }
  }

  String getMediumImageForUri(String uri) => _getImagesForUri(uri)?.mediumImage;

  String getLargeImageForUri(String uri) => _getImagesForUri(uri)?.largeImage;

  String getSmallImageForUri(String uri) => _getImagesForUri(uri)?.smallImage;

  SW.Images _getImagesForUri(String uri) {
    var imageJson = _artwork?.getItem(uri);
    return imageJson != null ? SW.Images.fromJson(imageJson) : null;
  }

  Stream<ArtworkState> _mapLoadArtworkEventsToState(
      LoadArtworkEvents event) async* {
    _streamSubscription?.cancel();
    _artwork?.dispose();

    _artwork = LocalStorage('artwork');
    _streamSubscription = webSocket.stream.listen(
      (event) {
        if (event is SW.ReceivedAlbumArt) {
          add(ReceivedAlbumArt(artwork: event.artwork));
        } else if (event is SW.ReceivedTrackList) {
          List<SW.TlTrack> trackList = event.trackList;
          if (trackList.isNotEmpty)
            add(GetAlbumArt(
                uris: trackList.map((tlTrack) => tlTrack.track.uri).toList()));
        }
      },
    );
  }

  Stream<ArtworkState> _mapReceivedAlbumArtToState(
      ReceivedAlbumArt event) async* {
    yield AlbumArtLoading();
    event.artwork.forEach((uri, images) {
      _artwork.setItem(uri, images);
    });
    yield AlbumArtReady();
  }

  Stream<ArtworkState> _mapGetAlbumArtToState(GetAlbumArt event) async* {
    yield AlbumArtLoading();
    var urisWithNoArtwork = event.uris
        .where((uri) => uri != null && _artwork.getItem(uri) == null)
        .toList();
    if (urisWithNoArtwork.isEmpty) return;
    webSocket.getImages(urisWithNoArtwork);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _artwork?.dispose();
    return super.close();
  }
}
