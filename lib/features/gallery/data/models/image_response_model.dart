import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';

class ImageResponseModel extends ImageModel {
  const ImageResponseModel({
    required super.id,
    required super.downloads,
    required super.height,
    required super.imageUrl,
    required super.likes,
    required super.previewUrl,
    required super.tags,
    required super.username,
    required super.views,
    required super.width,
  });

  factory ImageResponseModel.fromJson(Map<String, dynamic> json) {
    return ImageResponseModel(
      id: json['id'] as int? ?? 0,
      downloads: json['downloads'] as int? ?? 0,
      height: json['imageHeight'] as int? ?? 0,
      imageUrl: json['largeImageURL'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
      previewUrl: json['webformatURL'],
      tags: json['tags'] as String? ?? '',
      username: json['user'] as String? ?? 'NA',
      views: json['views'] as int? ?? 0,
      width: json['imageWidth'] as int? ?? 0,
    );
  }

  factory ImageResponseModel.fromEntity(ImageModel imagemodel) =>
      ImageResponseModel(
        id: imagemodel.id,
        downloads: imagemodel.downloads,
        height: imagemodel.height,
        imageUrl: imagemodel.imageUrl,
        likes: imagemodel.likes,
        previewUrl: imagemodel.previewUrl,
        tags: imagemodel.tags,
        username: imagemodel.username,
        views: imagemodel.views,
        width: imagemodel.width,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'webformatURL': previewUrl,
    'largeImageURL': imageUrl,
    'user': username,
    'tags': tags,
    'views': views,
    'likes': likes,
    'imageWidth': width,
    'imageHeight': height,
  };
}
