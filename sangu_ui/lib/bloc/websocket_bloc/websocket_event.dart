import 'package:equatable/equatable.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();
}

class LoadWebSocket extends WebSocketEvent {
  @override
  List<Object> get props => [];
}

class WebSocketRetrying extends WebSocketEvent {
  @override
  List<Object> get props => [];
}

class WebSocketFailed extends WebSocketEvent {
  final String errorMessage;

  WebSocketFailed({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => "WebSocketFailed { errorMessage: $errorMessage }";
}

class WebSocketClosed extends WebSocketEvent {
  final int code;
  final String reason;

  WebSocketClosed({this.code, this.reason});

  @override
  List<Object> get props => [code, reason];

  @override
  String toString() => "WebSocketClosed { code: $code, reason: $reason }";
}

class WebSocketConnected extends WebSocketEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "WebSocketConnected";
}
