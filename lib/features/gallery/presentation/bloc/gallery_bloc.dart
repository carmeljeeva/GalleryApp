import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/domain/usecases/image_usecases.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_event.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetImages getImages;

  GalleryBloc(this.getImages) : super(const GalleryState()) {
    on<GalleryStarted>((e, emit) => _load(emit, reset: true));
    on<GalleryRefreshed>((e, emit) => _load(emit, reset: true));
    on<GalleryNxtPageRequested>((e, emit) async {
      if (state.loadingMore ||
          state.hasReachedMax ||
          state.status != GalleryStatus.success) {
        return;
      }
      await _load(emit, reset: false);
    });
  }

  Future<void> _load(Emitter<GalleryState> emit, {required bool reset}) async {
    final page = reset ? 1 : state.page + 1;

    emit(
      reset
          ? state.copyWith(status: GalleryStatus.loading, clearError: true)
          : state.copyWith(loadingMore: true, clearError: true),
    );

    try {
      final result = await getImages.call(page: page);

      final newImages = reset
          ? result.images
          : [...state.images, ...result.images];

      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: newImages,
          page: page,
          loadingMore: false,
          hasReadchedMax:
              result.images.isEmpty ||
              (result.totalHits > 0 && newImages.length >= result.totalHits),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.failure,
          loadingMore: false,
          error: e.toString(),
          clearError: false,
        ),
      );
    }
  }
}
