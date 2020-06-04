import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/playback_bloc/bloc.dart';
import 'package:sangu/bloc/seek_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class SeekBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> with SingleTickerProviderStateMixin {
  int _duration;
  String _playBackState;
  PlaybackBloc _playbackBloc;
  SeekBloc _seekBloc;

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _duration = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration),
    );
    _playbackBloc = BlocProvider.of<PlaybackBloc>(context);
    _seekBloc = BlocProvider.of<SeekBloc>(context);
    _playbackBloc.listen((playbackState) {
      bool wasPlaying = _animationController.isAnimating;
      _playBackState = playbackState;
      switch (playbackState) {
        case TrackPlayingState:
          if (!wasPlaying) _animationController.forward();
          break;
        case TrackStoppedState:
        case TrackPausedState:
          if (wasPlaying) _animationController.stop();
          break;
        default:
          print(
              "Playback state is: $playbackState: No change needed for seekbar");
          break;
      }
    });
    _seekBloc.listen((seekState) {
      if (seekState is Loading) return;
      double newPosition =
          seekState.position / _animationController.duration.inMilliseconds;
      _animationController.reset();
      _animationController.forward(from: newPosition);
      if (_playBackState != TrackPlayingState) _animationController.stop();
    });
    _initPollSeekPosition();
  }

  Future _initPollSeekPosition() async {
    _seekBloc.add(GetTimePosition());
    while (_seekBloc != null) {
      await Future.delayed(
          const Duration(seconds: 2), () => _seekBloc.add(GetTimePosition()));
    }
  }

  getDuration() {
    Duration duration =
        _animationController.duration * _animationController?.value ?? 0;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackListBloc, TrackListState>(
      condition: (oldState, newState) =>
          oldState.currentTrack?.trackListId !=
          newState.currentTrack?.trackListId,
      builder: (context, state) {
        if (state.currentTrack != null) {
          _duration = state.currentTrack?.track?.length ?? 0;
          _animationController.duration = Duration(milliseconds: _duration);
          _animationController.reset();
          if (_playBackState == TrackPlayingState)
            _animationController.forward();
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 7.0),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget child) {
                        return Text(
                          _animationController.value > 0
                              ? getDuration()
                              : "0:00",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(fontSize: 12.0),
                        );
                      },
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget child) {
                    return CustomPaint(
                      foregroundPainter: ProgressPainter(
                          defaultColour: Color.fromRGBO(48, 48, 51, 1),
                          progressColour: Color.fromRGBO(122, 122, 122, 1),
                          lineWidth: 2.0,
                          animation: _animationController),
                      child: Row(),
                    );
                  }),
            ]);
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _playbackBloc.close();
    _seekBloc.close();
    super.dispose();
  }
}

class ProgressPainter extends CustomPainter {
  final Color defaultColour;
  final Color progressColour;
  final double lineWidth;
  final AnimationController animation;

  ProgressPainter(
      {this.defaultColour, this.progressColour, this.animation, this.lineWidth})
      : super(repaint: animation);

  _getPaint(Color color) {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint defaultPaint = _getPaint(defaultColour);
    Paint progressPaint = _getPaint(progressColour);
    Offset centerLeft = Offset(0, size.height / 2);
    Offset centerRight = Offset(size.width, size.height / 2);
    canvas.drawLine(centerLeft, centerRight, defaultPaint);
    canvas.drawLine(
        centerLeft,
        Offset(size.width * animation?.value ?? 0, size.height / 2),
        progressPaint);
  }

  @override
  bool shouldRepaint(ProgressPainter old) {
    return animation?.value != old.animation?.value;
  }
}
