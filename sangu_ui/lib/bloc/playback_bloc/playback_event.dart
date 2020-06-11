import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class PlaybackEvent extends Equatable {
  const PlaybackEvent();
}

class ResumeTrack extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "ResumeTrack";
}

class PlayTrack extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "PlayTrack";
}

class PauseTrack extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "PauseTrack";
}

class SkipTrack extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "SkipTrack";
}

class PreviousTrack extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "PreviousTrack";
}

class StopTrack extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "StopTrack";
}

class GetCurrentState extends PlaybackEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "GetCurrentState";
}

class TrackPlaybackChange extends PlaybackEvent {
  final String state;

  TrackPlaybackChange({this.state});

  @override
  List<Object> get props => [state];

  @override
  String toString() => "TrackPlaybackChange { state: $state }";
}
