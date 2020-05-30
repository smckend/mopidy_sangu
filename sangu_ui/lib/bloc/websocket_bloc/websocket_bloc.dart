import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/websocket_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  SW.SanguWebSocket webSocket;
  StreamSubscription _streamSubscription;

  WebSocketBloc({this.webSocket});

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
    _streamSubscription?.cancel();
    _streamSubscription = webSocket.isConnected
        ? webSocket.stream.listen(
            (event) {
              if (event is SW.WebSocketFailed) {
                add(WebSocketFailed(errorMessage: event.errorMessage));
              } else if (event is SW.WebSocketClosed) {
                add(WebSocketClosed(
                  reason: event.reason,
                  code: event.code,
                ));
              } else if (event is SW.WebSocketRetrying) {
                add(WebSocketRetrying());
              } else if (event is SW.WebSocketConnected) {
                add(WebSocketConnected());
              }
            },
            onError: (error) {
              print("Error event in websocket connection: $error");
            },
          )
        : null;
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
