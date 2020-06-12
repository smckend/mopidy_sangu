import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/widget/backend_icon.dart';
import 'package:sangu/widget/vote_widget.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class NowPlayingTrackInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackListBloc, TrackListState>(
        condition: (oldState, newState) =>
            oldState.currentTrack?.trackListId !=
            newState.currentTrack?.trackListId,
        builder: (BuildContext context, state) {
          TlTrack currentTlTrack = state.currentTrack;
          if (currentTlTrack == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  "Nothing Playing",
                  style: Theme.of(context).textTheme.headline4,
                  minFontSize: 14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<VoteBloc, VoteState>(
                        builder: (context, voteState) {
                          int _trackListId = currentTlTrack.trackListId;
                          int _votesForTrack = voteState is VotesReady
                              ? voteState.votes[_trackListId.toString()] ?? 0
                              : 0;
                          return Container(
                            height: 45,
                            width: 45,
                            child: VoteWidget(
                              trackListId: _trackListId,
                              votesForTrack: _votesForTrack,
                              buttonEnabled: false,
                              canVote: false,
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              currentTlTrack.track.name,
                              style: Theme.of(context).textTheme.headline4,
                              minFontSize: 14,
                              stepGranularity: 1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AutoSizeText(
                              "${currentTlTrack.track.getArtists()} / ${currentTlTrack.track.getLength()}",
                              style: Theme.of(context).textTheme.headline2,
                              minFontSize: 12,
                              stepGranularity: 1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: BackendIcon(track: currentTlTrack.track),
                ),
              ],
            );
          }
        });
  }
}
