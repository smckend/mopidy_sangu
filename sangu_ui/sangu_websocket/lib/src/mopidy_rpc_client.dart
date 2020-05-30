import 'package:flutter/material.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MopidyRpcClient {
  Client _rpcClient;
  WebSocketChannel _channel;

  MopidyRpcClient({@required Uri webSocketUri}) {
    _channel = WebSocketChannel.connect(webSocketUri);
    _rpcClient = Client(_channel.cast());
    _startPing();
  }

  Future _startPing() async {
    while (!_rpcClient.isClosed) {
      _rpcClient.sendNotification("ping");
      await Future.delayed(const Duration(seconds: 30), () => "wake");
    }
  }

  int get closeCode => _channel.closeCode;

  String get closeReason => _channel.closeReason;

  bool get isClosed => _rpcClient.isClosed;

  Future listen() async => await _rpcClient.listen();

  Future close() async => await _rpcClient.close();

  resume() => _rpcClient.sendNotification("core.playback.resume");

  pause() => _rpcClient.sendNotification("core.playback.pause");

  next() => _rpcClient.sendNotification("core.playback.next");

  Future get getVersion => _rpcClient.sendRequest("core.get_version");

  Future get getState => _rpcClient.sendRequest("core.playback.get_state");

  Future get getTimePosition =>
      _rpcClient.sendRequest("core.playback.get_time_position");

  Future get getTlTracks =>
      _rpcClient.sendRequest("core.tracklist.get_tl_tracks");

  play({int trackListId}) {
    return _rpcClient
        .sendNotification("core.playback.play", {"tlid": trackListId});
  }

  Future search({Map query, List uris}) {
    return _rpcClient
        .sendRequest("core.library.search", {"query": query, "uris": uris});
  }

  Future getImages(List uris) =>
      _rpcClient.sendRequest("core.library.get_images", {"uris": uris});

  Future lookup(List uris) =>
      _rpcClient.sendRequest("core.library.lookup", {"uris": uris});

  Future add(List<String> uris) =>
      _rpcClient.sendRequest("core.tracklist.add", {"uris": uris});

  Future remove(List<int> trackListIds) =>
      _rpcClient.sendRequest("core.tracklist.remove", {
        "criteria": {'tlid': trackListIds}
      });

  Future setConsume(bool boolean) =>
      _rpcClient.sendRequest("core.tracklist.set_consume", {"value": boolean});
}
