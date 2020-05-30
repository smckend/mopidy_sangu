import 'package:json_annotation/json_annotation.dart';

import 'artist.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
  Album(
    this.name,
    this.artists,
  );

  List<Artist> artists;
  String date;
  String name;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);

  @override
  String toString() {
    return 'Album { name: $name, artists: $artists }';
  }
}
