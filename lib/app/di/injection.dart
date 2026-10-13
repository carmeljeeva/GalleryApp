import 'package:get_it/get_it.dart';
import 'package:project_gallery/app/config/app_config.dart';
import 'package:project_gallery/core/network/api_client.dart';
import 'package:project_gallery/features/gallery/data/ds/favorites_local_ds.dart';
import 'package:project_gallery/features/gallery/data/ds/gallery_remote_ds.dart';
import 'package:project_gallery/features/gallery/data/repo/gallery_repo_impl.dart';
import 'package:project_gallery/features/gallery/domain/repo/gallery_repo.dart';
import 'package:project_gallery/features/gallery/domain/usecases/image_usecases.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/download/download_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/fav/favorites_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<GalleryRemoteDS>(
    () => GalleryRemoteDS(apiClient: sl(), apiKey: AppConfig.pixabayKey),
  );
  sl.registerLazySingleton<FavoritesLocalDs>(() => FavoritesLocalDs(sl()));

  sl.registerLazySingleton<GalleryRepo>(() => GalleryRepoImpl(sl(), sl()));

  sl.registerLazySingleton(() => GetImages(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => Togglefav(sl()));
  sl.registerLazySingleton(() => DownloadImages(sl()));

  sl.registerFactory(() => GalleryBloc(sl()));
  sl.registerFactory(() => FavoritesBloc(sl(), sl()));
  sl.registerFactory(() => DownloadBloc(sl()));
}
