import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LoginClient {
  final String scheme;
  final String host;
  final int port;
  final String basePath;

  LoginClient(
      {@required this.scheme,
      @required this.host,
      @required this.port,
      this.basePath = ""});

  postLogin(String password) async {
    Uri postUri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: basePath + "/admin/login",
    );
    var response = await http.post(postUri, body: {"password": password});
    return jsonDecode(response.body)["logged_in"];
  }
}
