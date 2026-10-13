import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/domain/repo/gallery_repo.dart';

class GetImages {
  final GalleryRepo _repo;
  GetImages(this._repo);
  Future<ApiResult> call({required int page}) {
    return _repo.fetchImages(page: page);
  }
}

class GetFavorites {
  final GalleryRepo _repo;
  GetFavorites(this._repo);

  List<ImageModel> call() => _repo.getFavorites();
}

class Togglefav {
  final GalleryRepo _repo;
  Togglefav(this._repo);
  Future<List<ImageModel>> call(ImageModel image) {
    return _repo.toggleFav(image);
  }
}

class DownloadImages {
  final GalleryRepo _repo;
  DownloadImages(this._repo);
  Future<void> call(ImageModel image, {void Function(double)? onProgress}) {
    return _repo.downloadImage(image);
  }
}
