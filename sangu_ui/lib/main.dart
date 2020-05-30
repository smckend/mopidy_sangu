import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu/bloc/audio_bloc/bloc.dart';
import 'package:sangu/bloc/config_bloc/bloc.dart';
import 'package:sangu/bloc/login_bloc/bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu/bloc/search_bloc/bloc.dart';
import 'package:sangu/bloc/seek_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
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
                path: "/mopidy/ws"));

  @override
  Widget build(BuildContext context) {
    var basePath = "/sangu/api";
    return MultiBlocProvider(
      providers: [
        BlocProvider<WebSocketBloc>(
          create: (BuildContext context) =>
              WebSocketBloc(webSocket: mopidyWebSocket)..add(LoadWebSocket()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) =>
              SearchBloc(webSocket: mopidyWebSocket)..add(LoadSearchEvents()),
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
            BlocProvider.of<UserVoteBloc>(context).add(LoadUserVotes(
                sessionId: (configState as Loaded).config.sessionId));
            BlocProvider.of<AudioBloc>(context).add(StartAudioStream(
              url: (configState as Loaded).config.streamUrl,
            ));
          },
          child: BlocBuilder<WebSocketBloc, WebSocketState>(
            builder: (context, socketState) {
              if (socketState is WebSocketLoading) {
                return LoadingPage();
              } else if (socketState is Disconnected) {
                return ErrorPage(
                    message: "Disconnected: ${socketState.reason}");
              } else if (socketState is FailedToConnect) {
                return ErrorPage(message: "Error: ${socketState.reason}");
              }
              return MultiBlocProvider(
                providers: [
                  BlocProvider<PlaybackBloc>(
                    create: (context) =>
                        PlaybackBloc(webSocket: mopidyWebSocket)
                          ..add(LoadPlaybackEvents()),
                  ),
                  BlocProvider<SeekBloc>(
                    create: (context) => SeekBloc(webSocket: mopidyWebSocket)
                      ..add(LoadSeekEvents())
                      ..add(GetTimePosition()),
                  ),
                  BlocProvider<TrackListBloc>(
                    create: (context) =>
                        TrackListBloc(webSocket: mopidyWebSocket)
                          ..add(LoadTracklistEvents())
                          ..add(UpdateTrackList())
                          ..add(SetIfDeleteTrackAfterPlay(boolean: true)),
                  ),
                  BlocProvider<ArtworkBloc>(
                    create: (context) => ArtworkBloc(webSocket: mopidyWebSocket)
                      ..add(LoadArtworkEvents()),
                  ),
                  BlocProvider<VoteBloc>(
                    create: (context) => VoteBloc(
                      webSocket: mopidyWebSocket,
                      voteClient: VoteClient(
                        scheme: mopidyScheme,
                        host: mopidyHost,
                        port: mopidyPort,
                        basePath: basePath,
                      ),
                    )..add(LoadVoteData()),
                  ),
                ],
                child: MainPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
