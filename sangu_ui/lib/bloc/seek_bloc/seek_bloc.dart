import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/seek_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class SeekBloc extends Bloc<SeekEvent, SeekState> {
  SanguWebSocket webSocket;

  SeekBloc({this.webSocket});

  @override
  SeekState get initialState => Loading();

  @override
  Stream<SeekState> mapEventToState(
    SeekEvent event,
  ) async* {
    if (event is GetTimePosition)
      webSocket.getTimePosition();
    else if (event is UpdateSeek) yield Seek(position: event.position);
  }
}
