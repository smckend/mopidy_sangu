import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
  String sessionId;
  String streamUrl;
  bool enablePlayButton;

  Config({this.sessionId, this.streamUrl, this.enablePlayButton});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  @override
  String toString() {
    return "Config { sessionId: $sessionId, streamUrl: $streamUrl, enablePlayButton: $enablePlayButton }";
  }
}
