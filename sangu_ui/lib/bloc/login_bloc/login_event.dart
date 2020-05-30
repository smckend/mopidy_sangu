import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginAttempt extends LoginEvent {
  final String password;

  LoginAttempt({this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => "LoginAttempt { password: <redacted>}";
}

class LoadLoginState extends LoginEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "LoadLoginState";
}
