// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
    sessionId: json['sessionId'] as String,
    streamUrl: json['streamUrl'] as String,
    enablePlayButton: json['enablePlayButton'] as bool,
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'sessionId': instance.sessionId,
      'streamUrl': instance.streamUrl,
      'enablePlayButton': instance.enablePlayButton,
    };
