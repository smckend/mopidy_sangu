import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/user_vote_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/widget/vote_widget.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class VoteButton extends StatelessWidget {
  final TlTrack tlTrack;
  final bool enabled;

  const VoteButton({Key key, this.tlTrack, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserVoteBloc, UserVoteState>(
      builder: (context, userVoteState) {
        return BlocBuilder<VoteBloc, VoteState>(
            builder: (BuildContext context, VoteState voteState) {
          bool _buttonEnabled = true;
          bool _canVote = false;
          int votesForTrack = 0;

          if (userVoteState is UserVotesReady) {
            _canVote = !userVoteState.votes
                .containsKey(tlTrack.trackListId.toString());
          } else {
            _buttonEnabled = false;
          }
          if (voteState is VotesReady) {
            votesForTrack =
                voteState.votes[tlTrack.trackListId.toString()] ?? 0;
          } else {
            _buttonEnabled = false;
          }
          _checkIfVoteFailed(voteState, context);
          _checkIfUnvoteFailed(voteState, context);

          return VoteWidget(
            trackListId: tlTrack.trackListId,
            buttonEnabled: _buttonEnabled && enabled,
            canVote: _canVote && enabled,
            votesForTrack: votesForTrack,
          );
        });
      },
    );
  }

  void _checkIfUnvoteFailed(VoteState voteState, BuildContext context) {
    if (voteState is UnvoteFailed) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Unvote for ${voteState.trackListId} failed ")));
      BlocProvider.of<UserVoteBloc>(context)
          .add(UserVoteForTrack(trackListId: voteState.trackListId));
    }
  }

  void _checkIfVoteFailed(VoteState voteState, BuildContext context) {
    if (voteState is VoteFailed) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Vote for ${voteState.trackListId} failed ")));
      BlocProvider.of<UserVoteBloc>(context)
          .add(UserUnvoteForTrack(trackListId: voteState.trackListId));
    }
  }
}
