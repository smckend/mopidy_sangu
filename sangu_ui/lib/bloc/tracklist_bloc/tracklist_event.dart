import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

@immutable
abstract class TrackListEvent extends Equatable {
  const TrackListEvent();
}

class LoadTracklistEvents extends TrackListEvent {
  @override
  List<Object> get props => [];
}

class AddTrack extends TrackListEvent {
  final Track track;

  AddTrack({this.track});

  @override
  List<Object> get props => [track];

  @override
  String toString() => "AddTrack { track: ${track.name} }";
}

class RemoveTrack extends TrackListEvent {
  final TlTrack tlTrack;

  RemoveTrack({this.tlTrack});

  @override
  List<Object> get props => [tlTrack];

  @override
  String toString() => "RemoveTrack { tlTrack: ${tlTrack.track.name}";
}

class SetIfDeleteTrackAfterPlay extends TrackListEvent {
  final bool boolean;

  SetIfDeleteTrackAfterPlay({this.boolean});

  @override
  List<Object> get props => [boolean];

  @override
  String toString() => "SetIfDeleteTrackAfterPlay { boolean: $boolean}";
}

class ReceivedTrackList extends TrackListEvent {
  final List<TlTrack> trackList;

  ReceivedTrackList({this.trackList});

  @override
  List<Object> get props => [trackList];

  @override
  String toString() => "ReceivedTrackList { # tracks: ${trackList.length} }";
}

class UpdateTrackList extends TrackListEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "UpdateTrackList";
}
