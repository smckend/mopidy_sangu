import 'package:flutter/cupertino.dart';
import 'package:sangu/extensions/track.dart';
import 'package:sangu_websocket/sangu_websocket.dart';
import 'package:url_launcher/url_launcher.dart';

class BackendIcon extends StatelessWidget {
  final Track track;

  const BackendIcon({Key key, this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String url = track.getUrl();
    return GestureDetector(
      onTap: () async {
        if (url == null) return;

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        height: 25.0,
        width: 25.0,
        child: FittedBox(
          fit: BoxFit.fill,
          child: track.getBackendImage(),
        ),
      ),
    );
  }
}
