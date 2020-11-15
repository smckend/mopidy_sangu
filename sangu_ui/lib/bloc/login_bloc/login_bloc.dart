import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/login_bloc/bloc.dart';
import 'package:sangu/client/login_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginClient loginClient;

  LoginBloc({this.loginClient}) : super( LoggedOut()) {
    add(LoadLoginState());
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginAttempt) {
      var password = event.password;
      bool loggedIn = await loginClient.postLogin(password);
      if (loggedIn) {
        var _appData = await SharedPreferences.getInstance();
        _appData.setBool("loggedIn", true);
        yield LoggedIn();
      }
    } else if (event is LoadLoginState) {
      var _appData = await SharedPreferences.getInstance();
      if (_appData.containsKey("loggedIn")) {
        yield LoggedIn();
      }
    }
  }
}
