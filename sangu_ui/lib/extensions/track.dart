import 'package:flutter/material.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

extension TrackExtension on Track {
  Widget getBackendImage() {
    switch (this.getBackend()) {
      case "spotify":
        return Image.asset("images/spotify.png");
        break;
      case "soundcloud":
        return Image.asset("images/soundcloud.png");
        break;
      default:
        return Icon(Icons.music_note);
        break;
    }
  }

  String getUrl() {
    switch (this.getBackend()) {
      case "spotify":
        return "https://open.spotify.com/track/${this.uri.split(":").last}";
        break;
      case "soundcloud":
      default:
        return null;
        break;
    }
  }
}
