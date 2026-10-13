import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';

abstract class GalleryRepo {
  Future<ApiResult> fetchImages({required int page});

  List<ImageModel> getFavorites();

  Future<List<ImageModel>> toggleFav(ImageModel image);
  Future<void> downloadImage(
    ImageModel image, {
    void Function(double progress)? onProgress,
  });
}
