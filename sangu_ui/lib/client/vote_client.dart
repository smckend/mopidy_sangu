import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class VoteClient {
  final String scheme;
  final String host;
  final int port;
  final String basePath;

  VoteClient(
      {@required this.scheme,
      @required this.host,
      @required this.port,
      this.basePath = ""});

  Future<http.Response> postVote(int trackListId) async {
    Uri postUri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: basePath + "/track/$trackListId/vote",
    );
    return await http.post(postUri);
  }

  Future<http.Response> postUnvote(int trackListId) async {
    Uri postUri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: basePath + "/track/$trackListId/unvote",
    );
    return await http.post(postUri);
  }

  getVotes(int trackListId) async {
    Uri getUri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: basePath + "/track/$trackListId/vote",
    );
    var response = await http.get(getUri);
    return jsonDecode(response.body)["votes"];
  }

  Future getVoteData() async {
    Uri getUri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: basePath + "/votes",
    );
    var response = await http.get(getUri);
    var body = jsonDecode(response.body);
    var map = {
      "votes": Map<String, int>.from(body["votes"]),
    };
    return map;
  }
}
