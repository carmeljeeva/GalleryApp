import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gallery/core/failures.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/domain/usecases/image_usecases.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadImages downloadImages;

  DownloadBloc(this.downloadImages) : super(DownloadState()) {
    on<DownloadRequested>((event, emit) async {
      if (state.status == DownloadStatus.downloading) return;
      emit(const DownloadState(status: DownloadStatus.downloading));
      try {
        await downloadImages(
          event.image,
          onProgress: (p) {
            if (!emit.isDone) {
              emit(
                DownloadState(status: DownloadStatus.downloading, progress: p),
              );
            }
          },
        );
        emit(
          const DownloadState(
            status: DownloadStatus.success,
            message: 'saved to your photos!',
          ),
        );
      } on Failure catch (e) {
        emit(DownloadState(status: DownloadStatus.failure, message: e.message));
      }
    });
  }
}
