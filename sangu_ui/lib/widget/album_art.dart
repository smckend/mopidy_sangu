import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class AlbumArtWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackListBloc, TrackListState>(
        condition: (oldState, newState) =>
            oldState.currentTrack?.trackListId !=
            newState.currentTrack?.trackListId,
        builder: (BuildContext context, state) {
          Track currentTrack = state.currentTrack?.track;
          return AspectRatio(
            aspectRatio: 0.9,
            child: FittedBox(
              alignment: Alignment.topLeft,
              fit: BoxFit.contain,
              child: BlocBuilder<ArtworkBloc, ArtworkState>(
                builder: (BuildContext context, ArtworkState artworkState) {
                  String imageUrl = BlocProvider.of<ArtworkBloc>(context)
                      .getMediumImageForUri(currentTrack?.uri);
                  return imageUrl != null
                      ? Image.network(imageUrl)
                      : FlutterLogo();
                },
              ),
            ),
          );
        });
  }
}
