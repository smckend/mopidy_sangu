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

  runApp(
    MyApp(
      mopidyScheme: scheme,
      mopidyHost: host,
      mopidyPort: port,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String mopidyScheme;
  final String mopidyHost;
  final int mopidyPort;
  final MopidyWebSocket mopidyWebSocket;
  final String apiPath = "/sangu/api";

  MyApp({this.mopidyScheme, this.mopidyHost, this.mopidyPort})
      : mopidyWebSocket = MopidyWebSocket(
          scheme: mopidyScheme,
          host: mopidyHost,
          port: mopidyPort,
        );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VoteBloc>(
          create: (context) => VoteBloc(
            voteClient: VoteClient(
              scheme: mopidyScheme,
              host: mopidyHost,
              port: mopidyPort,
              basePath: apiPath,
            ),
          )..add(LoadVoteData()),
        ),
        BlocProvider<ConfigBloc>(
          create: (BuildContext context) => ConfigBloc(
            configClient: ConfigClient(
              scheme: mopidyScheme,
              host: mopidyHost,
              port: mopidyPort,
              basePath: apiPath,
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
              basePath: apiPath,
            ),
          )..add(LoadLoginState()),
        ),
        BlocProvider<PlaybackBloc>(
          create: (context) => PlaybackBloc(webSocket: mopidyWebSocket),
        ),
        BlocProvider<SeekBloc>(
          create: (context) => SeekBloc(webSocket: mopidyWebSocket),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(webSocket: mopidyWebSocket),
        ),
        BlocProvider<TrackListBloc>(
          create: (context) => TrackListBloc(webSocket: mopidyWebSocket),
        ),
        BlocProvider<ArtworkBloc>(
          create: (context) =>
              ArtworkBloc(webSocket: mopidyWebSocket)..add(LoadArtworkEvents()),
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
              searchBloc: BlocProvider.of<SearchBloc>(context),
              seekBloc: BlocProvider.of<SeekBloc>(context),
              trackListBloc: BlocProvider.of<TrackListBloc>(context),
              playbackBloc: BlocProvider.of<PlaybackBloc>(context),
              artworkBloc: BlocProvider.of<ArtworkBloc>(context),
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
