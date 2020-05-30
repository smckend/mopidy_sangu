import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/config_bloc/bloc.dart';
import 'package:sangu/bloc/login_bloc/bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class NowPlayingControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlaybackBloc>(context).add(GetCurrentState());
    return BlocBuilder<PlaybackBloc, String>(
        builder: (BuildContext context, playbackState) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          BlocBuilder<ConfigBloc, ConfigState>(
            builder: (BuildContext context, ConfigState configState) {
              return BlocBuilder<LoginBloc, LoginState>(
                builder: (BuildContext context, LoginState loginState) {
                  return loginState is LoggedIn ||
                          (configState is Loaded &&
                              configState.config.enablePlayButton)
                      ? GestureDetector(
                          onTap: () {
                            switch (playbackState) {
                              case TrackPlayingState:
                                BlocProvider.of<PlaybackBloc>(context)
                                    .add(PauseTrack());
                                break;
                              case TrackStoppedState:
                                BlocProvider.of<PlaybackBloc>(context)
                                    .add(PlayTrack());
                                break;
                              default:
                                BlocProvider.of<PlaybackBloc>(context)
                                    .add(ResumeTrack());
                                break;
                            }
                          },
                          child: AnimatedCrossFade(
                            duration: Duration(milliseconds: 200),
                            crossFadeState: playbackState == TrackPlayingState
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Icon(
                              Icons.pause,
                              size: 50,
                            ),
                            secondChild: Icon(
                              Icons.play_arrow,
                              size: 50,
                            ),
                          ),
                        )
                      : Container();
                },
              );
            },
          ),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (BuildContext context, LoginState state) {
              return state is LoggedIn
                  ? GestureDetector(
                      onTap: () {
                        BlocProvider.of<PlaybackBloc>(context).add(SkipTrack());
                      },
                      child: Icon(
                        Icons.skip_next,
                        size: 50,
                      ),
                    )
                  : Container();
            },
          )
        ],
      );
    });
  }
}
