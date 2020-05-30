import 'package:json_annotation/json_annotation.dart';

import 'track.dart';

part 'tlTrack.g.dart';

@JsonSerializable()
class TlTrack {
  @JsonKey(name: "tlid")
  int trackListId;
  Track track;

  TlTrack(this.trackListId, this.track);

  factory TlTrack.fromJson(Map<String, dynamic> json) =>
      _$TlTrackFromJson(json);

  Map<String, dynamic> toJson() => _$TlTrackToJson(this);

  @override
  String toString() {
    return 'TlTrack { trackListId: $trackListId, track: $track }';
  }
}
