import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SeekEvent extends Equatable {
  const SeekEvent();
}

class LoadSeekEvents extends SeekEvent {
  @override
  List<Object> get props => [];
}

class UpdateSeek extends SeekEvent {
  final int position;

  UpdateSeek({this.position});

  @override
  List<Object> get props => [position];

  @override
  String toString() => "Seek { newPosition: $position }";
}

class GetTimePosition extends SeekEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "GetTimePosition";
}
