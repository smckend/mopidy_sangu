import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:sangu/widget/album_art.dart';
import 'package:sangu/widget/now_playing_control.dart';
import 'package:sangu/widget/now_playing_info.dart';
import 'package:sangu/widget/seek_bar.dart';

class NowPlayingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 26.0, bottom: 5.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Now Playing",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 26.0, right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AlbumArtWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(flex: 1, child: NowPlayingTrackInfo()),
                        Expanded(
                          flex: 2,
                          child: NowPlayingControl(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Flexible(
            child: Padding(
                padding: EdgeInsets.only(left: 26.0, right: 26.0),
                child: SeekBar())),
      ],
    );
  }
}
