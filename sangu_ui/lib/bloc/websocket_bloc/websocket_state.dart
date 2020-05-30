import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class WebSocketState extends Equatable {
  const WebSocketState();
}

class WebSocketLoading extends WebSocketState {
  @override
  List<Object> get props => [];
}

class Disconnected extends WebSocketState {
  final String reason;

  Disconnected({this.reason});

  @override
  List<Object> get props => [reason];
}

class FailedToConnect extends WebSocketState {
  final String reason;

  FailedToConnect({this.reason});

  @override
  List<Object> get props => [reason];
}

class Connected extends WebSocketState {
  @override
  List<Object> get props => [];
}
