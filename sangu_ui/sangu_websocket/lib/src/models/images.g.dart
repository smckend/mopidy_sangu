// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    smallImage: json['smallImage'] as String,
    mediumImage: json['mediumImage'] as String,
    largeImage: json['largeImage'] as String,
  );
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'smallImage': instance.smallImage,
      'mediumImage': instance.mediumImage,
      'largeImage': instance.largeImage,
    };
