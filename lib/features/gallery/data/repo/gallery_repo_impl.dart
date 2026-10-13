import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_gallery/core/failures.dart';
import 'package:project_gallery/features/gallery/data/ds/favorites_local_ds.dart';
import 'package:project_gallery/features/gallery/data/ds/gallery_remote_ds.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/domain/repo/gallery_repo.dart';

class GalleryRepoImpl implements GalleryRepo {
  final GalleryRemoteDS remoteDS;
  final FavoritesLocalDs favoritesLocalDs;
  final Dio _downloader = Dio();

  GalleryRepoImpl(this.remoteDS, this.favoritesLocalDs);
  @override
  Future<ApiResult> fetchImages({required int page}) {
    return remoteDS.fetchImages(page: page);
  }

  @override
  Future<void> downloadImage(
    ImageModel image, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      if (!await Gal.hasAccess()) {
        if (!await Gal.requestAccess()) {
          throw const Failure('Permission denied!');
        }
      }
      final dir = await getTemporaryDirectory();
      final savepath = '${dir.path}/pixabay_${image.id}.jpg';
      await _downloader.download(
        image.imageUrl,
        savepath,
        onReceiveProgress: (received, total) {
          if (total > 0) onProgress?.call(received / total);
        },
      );
      await Gal.putImage(savepath);
      final file = File(savepath);
      if (await file.exists()) {
        await file.delete();
      }
    } on Failure {
      rethrow;
    } on DioException {
      throw const Failure('Download failed!');
    } on GalException {
      throw const Failure('could notsave the image!');
    } catch (_) {
      throw const Failure('something went wrong!');
    }
  }

  @override
  List<ImageModel> getFavorites() {
    return favoritesLocalDs.read();
  }

  @override
  Future<List<ImageModel>> toggleFav(ImageModel image) async {
    final list = [...favoritesLocalDs.read()];
    final index = list.indexWhere((e) => e.id == image.id);
    index >= 0 ? list.removeAt(index) : list.insert(0, image);
    await favoritesLocalDs.write(list);
    return list;
  }
}
