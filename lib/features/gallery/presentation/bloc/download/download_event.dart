part of 'download_bloc.dart';

sealed class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadRequested extends DownloadEvent {
  final ImageModel image;
  const DownloadRequested(this.image);
}
