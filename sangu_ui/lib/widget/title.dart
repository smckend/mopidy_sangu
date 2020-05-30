import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/tracklist_bloc/bloc.dart';
import 'package:sangu/widget/search.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class SanguTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "SANGU",
          style: Theme.of(context).textTheme.headline5,
        ),
        IconButton(
          icon: Icon(Icons.search),
          iconSize: 30.0,
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
      ],
    );
  }
}
