import 'package:equatable/equatable.dart';

abstract class AudioState extends Equatable {
  const AudioState();
}

class NoAudio extends AudioState {
  @override
  List<Object> get props => [];
}

class AudioLoading extends AudioState {
  @override
  List<Object> get props => [];
}

class AudioFailed extends AudioState {
  final String error;

  AudioFailed({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "AudioFailed { error: $error }";
}

class AudioMuted extends AudioState {
  @override
  List<Object> get props => [];
}

class AudioUnmuted extends AudioState {
  @override
  List<Object> get props => [];
}
