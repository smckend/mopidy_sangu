import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoggedOut extends LoginState {
  @override
  List<Object> get props => [];
}

class LoggedIn extends LoginState {
  @override
  List<Object> get props => [];
}
