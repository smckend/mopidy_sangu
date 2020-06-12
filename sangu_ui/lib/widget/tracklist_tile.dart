import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sangu/bloc/artwork_bloc/bloc.dart';
import 'package:sangu/widget/backend_icon.dart';
import 'package:sangu/widget/vote_button.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

class TrackListTile extends StatelessWidget {
  final TlTrack tlTrack;
  final bool buttonEnabled;

  const TrackListTile({Key key, this.tlTrack, this.buttonEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Container(
          height: 45,
          width: 105,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: VoteButton(
                    tlTrack: tlTrack,
                    enabled: buttonEnabled,
                  ),
                ),
              ),
              Container(
                height: 45.0,
                width: 45.0,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: BlocBuilder<ArtworkBloc, ArtworkState>(
                    builder: (BuildContext context, ArtworkState artworkState) {
                      String imageUrl = artworkState is AlbumArtReady
                          ? artworkState
                              .artwork[tlTrack?.track?.uri]?.smallImage
                          : null;
                      return imageUrl != null
                          ? Image.network(imageUrl)
                          : FlutterLogo();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        title: Text(
          tlTrack.track.name,
          style: Theme.of(context).textTheme.headline3,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${tlTrack.track.getArtists()} / ${tlTrack.track.getLength()}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline2,
        ),
        trailing: BackendIcon(track: tlTrack.track));
  }
}
