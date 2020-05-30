import 'package:equatable/equatable.dart';

abstract class SeekState extends Equatable {
  final int position;

  const SeekState({this.position});

  @override
  List<Object> get props => [position];
}

class Loading extends SeekState {}

class Seek extends SeekState {
  final int position;

  Seek({this.position});

  @override
  List<Object> get props => [position];
}
