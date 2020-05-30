import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sangu/bloc/login_bloc/bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu/widget/tracklist_tile.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class TrackListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrackListWidgetState();
}

class _TrackListWidgetState extends State<TrackListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackListBloc, TrackListState>(
      condition: (oldState, newState) => !ListEquality().equals(
          oldState.trackList.map((track) => track.trackListId).toList(),
          newState.trackList.map((track) => track.trackListId).toList()),
      builder: (BuildContext context, TrackListState state) {
        List<TlTrack> trackList = state.trackList;
        return Scrollbar(
          child: ImplicitlyAnimatedList<TlTrack>(
            padding: const EdgeInsets.only(
              top: 13.0,
              bottom: 13.0,
              left: 18.0,
              right: 30.0,
            ),
            areItemsTheSame: (track1, track2) =>
                track1.trackListId == track2.trackListId,
            items: trackList,
            itemBuilder: (context, animation, tlTrack, index) {
              return BlocBuilder<LoginBloc, LoginState>(
                builder: (BuildContext context, LoginState state) {
                  Widget _listTile = SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeIn,
                    animation: animation,
                    child: TrackListTile(tlTrack: tlTrack),
                  );
                  return state is LoggedIn
                      ? Dismissible(
                          key: Key(tlTrack.trackListId.toString()),
                          onDismissed: (DismissDirection direction) {
                            BlocProvider.of<TrackListBloc>(context)
                                .add(RemoveTrack(tlTrack: tlTrack));
                            setState(() {
                              trackList.removeAt(index);
                            });
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("${tlTrack.track.name} dismissed")));
                          },
                          background: Container(color: Colors.red),
                          child: _listTile,
                        )
                      : _listTile;
                },
              );
            },
            removeItemBuilder: (context, animation, oldTlTrack) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeOut,
                animation: animation,
                child: TrackListTile(
                  tlTrack: oldTlTrack,
                  buttonEnabled: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
