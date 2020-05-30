import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/seek_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class SeekBloc extends Bloc<SeekEvent, SeekState> {
  SW.SanguWebSocket webSocket;
  StreamSubscription _streamSubscription;

  SeekBloc({this.webSocket});

  @override
  SeekState get initialState => Loading();

  @override
  Stream<SeekState> mapEventToState(
    SeekEvent event,
  ) async* {
    if (event is LoadSeekEvents) {
      yield* _mapLoadSeekEventsToState(event);
    }
    if (event is GetTimePosition) {
      webSocket.getTimePosition();
    } else if (event is UpdateSeek) {
      yield Seek(position: event.position);
    }
  }

  Stream<SeekState> _mapLoadSeekEventsToState(LoadSeekEvents event) async* {
    _streamSubscription?.cancel();
    _streamSubscription = webSocket.stream.listen(
      (event) {
        if (event is SW.Seeked) {
          add(UpdateSeek(position: event.position));
        } else if (event is SW.ReceivedTrackList) {
          add(GetTimePosition());
        }
      },
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
