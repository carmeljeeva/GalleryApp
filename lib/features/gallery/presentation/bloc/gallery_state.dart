import 'package:equatable/equatable.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';

enum GalleryStatus { initial, loading, success, failure }

class GalleryState extends Equatable {
  final GalleryStatus status;
  final List<ImageModel> images;
  final int page;
  final bool hasReachedMax;
  final bool loadingMore;
  final String? error;

  const GalleryState({
    this.status = GalleryStatus.initial,
    this.error,
    this.images = const [],
    this.page = 0,
    this.hasReachedMax = false,
    this.loadingMore = false,
  });

  GalleryState copyWith({
    GalleryStatus? status,
    List<ImageModel>? images,
    int? page,
    bool? hasReadchedMax,
    bool? loadingMore,
    String? error,
    bool clearError = false,
  }) {
    return GalleryState(
      status: status ?? this.status,
      images: images ?? this.images,
      page: page ?? this.page,
      hasReachedMax: hasReadchedMax ?? this.hasReachedMax,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    status,
    images,
    page,
    hasReachedMax,
    loadingMore,
    error,
  ];
}

