part of 'download_bloc.dart';

enum DownloadStatus { initial, downloading, success, failure }

 class DownloadState extends Equatable {
  final DownloadStatus status;
  final double progress;
  final String? message;

  const DownloadState({
    this.status = DownloadStatus.initial,
    this.progress = 0,
    this.message ,
  });

  @override
  List<Object?> get props => [status, progress, message];
}


