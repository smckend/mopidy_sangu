import 'package:equatable/equatable.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

abstract class TrackListState extends Equatable {
  final TlTrack currentTrack;
  final List<TlTrack> trackList;

  const TrackListState({this.currentTrack, this.trackList = const []});

  @override
  List<Object> get props => [currentTrack, trackList];
}

class TrackListLoading extends TrackListState {
  @override
  String toString() => "TrackListLoading";
}

class TrackListReady extends TrackListState {
  final TlTrack currentTrack;
  final List<TlTrack> trackList;

  TrackListReady({this.currentTrack, this.trackList = const []});

  @override
  List<Object> get props => [trackList, currentTrack];

  @override
  String toString() =>
      "TrackListReady { currentTrack: $currentTrack, trackList: $trackList }";
}
