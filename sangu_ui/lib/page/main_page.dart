import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu/bloc/seek_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/widget/app_bar.dart';
import 'package:sangu/widget/background.dart';
import 'package:sangu/widget/now_playing.dart';
import 'package:sangu/widget/search.dart';
import 'package:sangu/widget/tracklist.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    BlocProvider.of<TrackListBloc>(context).add(UpdateTrackList());
    BlocProvider.of<PlaybackBloc>(context).add(GetCurrentState());
    BlocProvider.of<SeekBloc>(context).add(GetTimePosition());
    BlocProvider.of<VoteBloc>(context).add(UpdateVotes());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<TrackListBloc>(context).add(UpdateTrackList());
      BlocProvider.of<PlaybackBloc>(context).add(GetCurrentState());
      BlocProvider.of<SeekBloc>(context).add(GetTimePosition());
      BlocProvider.of<VoteBloc>(context).add(UpdateVotes());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width < 767 ? 240.0 : 280.0,
              child: Stack(
                children: <Widget>[
                  SanguBackground(),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Column(
                      children: <Widget>[
                        SanguAppBar(),
                        Expanded(
                          child: NowPlayingWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TrackListWidget(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Add a song",
          onPressed: () async {
            Track selectedTrack = await showSearch(
              context: context,
              delegate: SanguSearchWidget(),
            );
            if (selectedTrack != null)
              BlocProvider.of<TrackListBloc>(context)
                  .add(AddTrack(track: selectedTrack));
          },
        ),
      );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
