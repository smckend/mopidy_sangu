import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ConfigClient {
  final String scheme;
  final String host;
  final int port;
  final String basePath;

  ConfigClient(
      {@required this.scheme,
      @required this.host,
      @required this.port,
      this.basePath = ""});

  getConfig() async {
    Uri getUri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: basePath + "/config",
    );
    var response = await http.get(getUri);
    return jsonDecode(response.body)["config"];
  }
}
