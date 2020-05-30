import 'package:sangu_websocket/sangu_websocket.dart';

import 'models/models.dart';

abstract class SanguWebSocket {
  Stream get stream;

  bool get isConnected;

  Future<void> retryConnection() async {}

  Future<void> resumePlayback() async {}

  Future<void> pausePlayback() async {}

  Future<void> playTrack() async {}

  Future<void> nextTrack() async {}

  Future<void> getCurrentTrack() async {}

  Future<void> getCurrentState() async {}

  Future<void> search(Map query) async {}

  Future<void> getTrackList() async {}

  Future<void> setDeleteSongAfterPlay(bool boolean) async {}

  Future<void> getImages(List<String> uris) async {}

  Future<void> addTrackToTrackList(Track track) async {}

  Future<void> removeTrackFromTrackList(TlTrack tlTrack) async {}

  Future<void> playTrackIfNothingElseIsPlaying() async {}

  Future<void> getTimePosition() async {}

  void dispose() {}
}
