import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class Images {
  String smallImage;
  String mediumImage;
  String largeImage;

  Images({this.smallImage, this.mediumImage, this.largeImage});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);

  @override
  String toString() {
    return 'Images { smallImage: $smallImage, mediumImage: $mediumImage, largeImage: $largeImage }';
  }
}
