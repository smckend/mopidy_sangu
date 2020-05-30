// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tlTrack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TlTrack _$TlTrackFromJson(Map<String, dynamic> json) {
  return TlTrack(
    json['tlid'] as int,
    json['track'] == null
        ? null
        : Track.fromJson(json['track'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TlTrackToJson(TlTrack instance) => <String, dynamic>{
      'tlid': instance.trackListId,
      'track': instance.track,
    };
