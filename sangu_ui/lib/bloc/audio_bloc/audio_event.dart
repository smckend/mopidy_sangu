import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();
}

class StartAudioStream extends AudioEvent {
  final String url;

  StartAudioStream({this.url});

  @override
  List<Object> get props => [url];

  @override
  String toString() => "StreamAudio { uri: $url}";
}

class LoadAudio extends AudioEvent {
  @override
  List<Object> get props => [];
}

class MuteAudio extends AudioEvent {
  @override
  List<Object> get props => [];
}

class UnmuteAudio extends AudioEvent {
  @override
  List<Object> get props => [];
}
