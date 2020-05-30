import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/user_vote_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/bloc.dart';
import 'package:sangu/bloc/vote_bloc/vote_event.dart';

class VoteWidget extends StatelessWidget {
  final bool canVote;
  final int trackListId;
  final bool buttonEnabled;
  final int votesForTrack;

  const VoteWidget(
      {Key key,
      this.canVote,
      this.trackListId,
      this.buttonEnabled,
      this.votesForTrack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _buttonClicked = false;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: IconButton(
              icon: Icon(canVote ? Icons.favorite_border : Icons.favorite),
              padding: EdgeInsets.all(0.0),
              enableFeedback: buttonEnabled,
              splashColor: buttonEnabled ? Theme.of(context).splashColor : Colors.transparent,
              hoverColor: buttonEnabled ? Theme.of(context).hoverColor : Colors.transparent,
              highlightColor: buttonEnabled ? Theme.of(context).highlightColor : Colors.transparent,
              onPressed: () async {
                if (!_buttonClicked && buttonEnabled) {
                  _buttonClicked = true;
                  if (canVote) {
                    BlocProvider.of<UserVoteBloc>(context)
                        .add(UserVoteForTrack(trackListId: trackListId));

                    BlocProvider.of<VoteBloc>(context)
                        .add(VoteForTrack(trackListId: trackListId));
                  } else {
                    if (votesForTrack > 0) {
                      BlocProvider.of<VoteBloc>(context)
                          .add(UnvoteForTrack(trackListId: trackListId));
                      BlocProvider.of<UserVoteBloc>(context)
                          .add(UserUnvoteForTrack(trackListId: trackListId));
                    }
                  }
                }
              },
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              votesForTrack.toString(),
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline3.fontFamily,
                  color: canVote
                      ? Theme.of(context).textTheme.headline2.color
                      : Theme.of(context).textTheme.headline3.color,
                  fontSize: 9.0),
            ),
          ),
        ],
      ),
    );
  }
}
