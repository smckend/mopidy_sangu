import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/audio_bloc/bloc.dart';
import 'package:sangu/bloc/config_bloc/bloc.dart';
import 'package:sangu/bloc/login_bloc/bloc.dart';
import 'package:sangu/bloc/user_vote_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/bloc/websocket_bloc/bloc.dart';
import 'package:sangu/client/config_client.dart';
import 'package:sangu/client/login_client.dart';
import 'package:sangu/client/vote_client.dart';
import 'package:sangu/page/error_page.dart';
import 'package:sangu/page/loading_page.dart';
import 'package:sangu/page/main_page.dart';
import 'package:sangu/theme.dart';
import 'package:sangu_websocket/sangu_websocket.dart';
import 'package:universal_html/html.dart';

import 'bloc/websocket_bloc/websocket_state.dart';

void main() {
  var host =
      window.location.hostname != "" ? window.location.hostname : "10.0.2.2";
  var scheme = window.location.protocol.contains("https") ? "https" : "http";
  var port;
  if (kReleaseMode) {
    port = window.location.port != "" ? window.location.port : null;
  } else {
    port = 6680;
  }

  host = "sangu.cloud";
  scheme = "https";
  port = null;

  runApp(MyApp(
    mopidyScheme: scheme,
    mopidyHost: host,
    mopidyPort: port,
  ));
}

class MyApp extends StatelessWidget {
  final String mopidyScheme;
  final String mopidyHost;
  final int mopidyPort;
  final MopidyWebSocket mopidyWebSocket;

  MyApp({this.mopidyScheme, this.mopidyHost, this.mopidyPort})
      : mopidyWebSocket = MopidyWebSocket(
          webSocketUri: Uri(
            scheme: mopidyScheme == "https" ? "wss" : "ws",
            host: mopidyHost,
            port: mopidyPort,
            path: "/mopidy/ws",
          ),
        );

  @override
  Widget build(BuildContext context) {
    var basePath = "/sangu/api";
    return MultiBlocProvider(
      providers: [
        BlocProvider<VoteBloc>(
          create: (context) => VoteBloc(
            voteClient: VoteClient(
              scheme: mopidyScheme,
              host: mopidyHost,
              port: mopidyPort,
              basePath: basePath,
            ),
          )..add(LoadVoteData()),
        ),
        BlocProvider<ConfigBloc>(
          create: (BuildContext context) => ConfigBloc(
            configClient: ConfigClient(
              scheme: mopidyScheme,
              host: mopidyHost,
              port: mopidyPort,
              basePath: basePath,
            ),
          )..add(LoadConfig()),
        ),
        BlocProvider<UserVoteBloc>(create: (context) => UserVoteBloc()),
        BlocProvider<AudioBloc>(create: (context) => AudioBloc()),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            loginClient: LoginClient(
              scheme: mopidyScheme,
              host: mopidyHost,
              port: mopidyPort,
              basePath: basePath,
            ),
          )..add(LoadLoginState()),
        ),
      ],
      child: MaterialApp(
        title: 'Mopidy Sangu',
        debugShowCheckedModeBanner: false,
        theme: sanguTheme,
        home: BlocListener<ConfigBloc, ConfigState>(
          condition: (_, newState) => newState is Loaded,
          listener: (BuildContext context, configState) {
            BlocProvider.of<UserVoteBloc>(context).add(
              LoadUserVotes(
                sessionId: (configState as Loaded).config.sessionId,
              ),
            );
            BlocProvider.of<AudioBloc>(context).add(
              StartAudioStream(
                url: (configState as Loaded).config.streamUrl,
              ),
            );
          },
          child: BlocProvider<WebSocketBloc>(
            create: (BuildContext context) => WebSocketBloc(
              webSocket: mopidyWebSocket,
              voteBloc: BlocProvider.of<VoteBloc>(context),
            )..add(LoadWebSocket()),
            child: BlocBuilder<WebSocketBloc, WebSocketState>(
              builder: (context, socketState) {
                if (socketState is WebSocketLoading)
                  return LoadingPage();
                else if (socketState is Disconnected) {
                  return ErrorPage(
                      message: "Disconnected: ${socketState.reason}");
                } else if (socketState is FailedToConnect)
                  return ErrorPage(message: "Error: ${socketState.reason}");
                return MainPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
