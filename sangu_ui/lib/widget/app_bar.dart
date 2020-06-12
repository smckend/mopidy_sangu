import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/audio_bloc/audio_bloc.dart';
import 'package:sangu/bloc/audio_bloc/bloc.dart';
import 'package:sangu/bloc/login_bloc/bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class SanguAppBar extends StatefulWidget {
  final bool searchEnabled;

  const SanguAppBar({Key key, this.searchEnabled = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SanguAppState(searchEnabled);
}

class SanguAppState extends State<SanguAppBar> {
  final bool streamEnabled;

  final myController = TextEditingController();
  bool showLogin = false;

  SanguAppState(this.streamEnabled);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      backgroundColor: Colors.transparent,
      titleSpacing: 26,
      elevation: 0,
      title: showLogin
          ? _loginForm()
          : GestureDetector(
              onTap: () {
                _updateTitleWidget();
              },
              child: Text(
                "SANGU",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
      actions: <Widget>[
        BlocListener<PlaybackBloc, String>(
          listener: (context, playbackState) {
            if (playbackState == TrackPlayingState) {
              BlocProvider.of<AudioBloc>(context).add(LoadAudio());
            }
          },
          child: BlocBuilder<AudioBloc, AudioState>(
            builder: (context, audioState) {
              if (audioState is AudioFailed || audioState is NoAudio) {
                return Container();
              }
              if (audioState is AudioLoading) {
                return Padding(
                  padding: EdgeInsets.only(right: 25.0),
                  child: SizedBox(
                    height: 10.0,
                    width: 35.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(right: 18.0),
                child: IconButton(
                  tooltip: "Toggle sound",
                  icon: Icon(audioState is AudioUnmuted
                      ? Icons.volume_up
                      : Icons.volume_mute),
                  onPressed: () {
                    BlocProvider.of<AudioBloc>(context).add(
                        audioState is AudioUnmuted
                            ? MuteAudio()
                            : UnmuteAudio());
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }

  void _updateTitleWidget() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Widget _loginForm() {
    void attemptLogin() {
      BlocProvider.of<LoginBloc>(context)
          .add(LoginAttempt(password: myController.text));
      _updateTitleWidget();
      myController.clear();
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            style: Theme.of(context).textTheme.headline3,
            cursorColor: Color.fromRGBO(153, 153, 159, 1),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(153, 153, 159, 1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(153, 153, 159, 1)),
              ),
            ),
            onSubmitted: (_) {
              attemptLogin();
            },
            controller: myController,
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              attemptLogin();
            },
            child: Icon(Icons.send),
          ),
        )
      ],
    );
  }
}
