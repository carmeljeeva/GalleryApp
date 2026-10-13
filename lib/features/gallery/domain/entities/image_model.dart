import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final int id;
  final String previewUrl;
  final String imageUrl;
  final String tags;
  final String username;
  final int likes;
  final int views;
  final int downloads;
  final int width;
  final int height;

  const ImageModel({
    required this.id,
    required this.downloads,
    required this.height,
    required this.imageUrl,
    required this.likes,
    required this.previewUrl,
    required this.tags,
    required this.username,
    required this.views,
    required this.width,
  });

  @override
  List<Object?> get props => [
    id,
    previewUrl,
    imageUrl,
    previewUrl,
    tags,
    username,
    likes,
    views,
    downloads,
    width,
    height,
  ];

  //description;
  String get description =>
      'Photo Uploaded by $username on Pixabay. Tags: $tags';
  double get aspectRatio => (width > 0 && height > 0) ? width / height : 1.5;
}

class ApiResult {
  final List<ImageModel> images;
  final int totalHits;
  const ApiResult({required this.images, required this.totalHits});
}
