import 'package:json_annotation/json_annotation.dart';

import 'album.dart';
import 'artist.dart';

part 'track.g.dart';

@JsonSerializable()
class Track {
  Track(
    this.name,
    this.artists,
    this.album,
    this.length,
    this.uri,
  );

  Album album;
  List<Artist> artists;
  String name;
  int length;
  String uri;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);

  String getArtists() {
    return this.artists.map((Artist a) {
      return a.name;
    }).reduce((String artistName1, String artistName2) {
      return artistName1 + " & " + artistName2;
    });
  }

  String getLength() {
    Duration duration = Duration(milliseconds: this.length);
    int remainingSeconds = duration.inSeconds % 60;
    return "${duration.inMinutes}:${remainingSeconds < 10 ? "0$remainingSeconds" : remainingSeconds.toString()}";
  }

  String getBackend() {
    return this.uri.split(':').first;
  }

  @override
  String toString() {
    return 'Track { name: $name, artists: $artists, album: $album, length: $length, uri: $uri }';
  }
}
