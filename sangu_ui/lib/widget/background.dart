import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class SanguBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocBuilder<TrackListBloc, TrackListState>(
            condition: (oldState, newState) =>
                oldState.currentTrack?.trackListId !=
                newState.currentTrack?.trackListId,
            builder: (BuildContext context, trackListState) {
              Track currentTrack = trackListState.currentTrack?.track;
              return BlocBuilder<ArtworkBloc, ArtworkState>(
                builder: (BuildContext context, artworkState) {
                  String imageUrl = BlocProvider.of<ArtworkBloc>(context)
                      .getLargeImageForUri(currentTrack?.uri);
                  return RepaintBoundary(
                    child: Container(
                      decoration: imageUrl != null
                          ? BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              backgroundBlendMode: BlendMode.color,
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            )
                          : BoxDecoration(),
                    ),
                  );
                },
              );
            }),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).backgroundColor.withOpacity(0.3),
                  Theme.of(context).backgroundColor,
                ],
                stops: [
                  0,
                  1
                ]),
          ),
        )
      ],
    );
  }
}
