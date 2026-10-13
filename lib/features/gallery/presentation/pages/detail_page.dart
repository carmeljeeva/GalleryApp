import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gallery/app/di/injection.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/download/download_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/fav/favorites_bloc.dart';

class DetailPage extends StatelessWidget {
  final ImageModel image;
  const DetailPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (_) => sl<DownloadBloc>(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocSelector<FavoritesBloc, List<ImageModel>, bool>(
              selector: (f) => f.any((e) => e.id == image.id),
              builder: (context, isFav) => IconButton(
                onPressed: () =>
                    context.read<FavoritesBloc>().add(FavoriteToggle(image)),
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'img_${image.id}',
                    child: AspectRatio(
                      aspectRatio: image.aspectRatio,
                      child: CachedNetworkImage(
                        imageUrl: image.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => CachedNetworkImage(
                          imageUrl: image.previewUrl,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (_, _, _) =>
                            Icon(Icons.broken_image_sharp, size: 46),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          image.description,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(label: Text('${image.views} views')),
                            Chip(label: Text('${image.downloads} downloads')),
                            Chip(label: Text('${image.likes} likes')),
                            Chip(
                              label: Text('${image.width}x ${image.height}'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DownloadButton(image: image),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  final ImageModel image;
  const DownloadButton({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloadBloc, DownloadState>(
      listenWhen: (previous, current) =>
          current.status == DownloadStatus.success ||
          current.status == DownloadStatus.failure,
      listener: (context, s) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(s.message ?? ''))),
      builder: (context, s) {
        if (s.status == DownloadStatus.downloading) {
          return Column(
            children: [
              LinearProgressIndicator(
                value: s.progress == 0 ? null : s.progress,
              ),
              const SizedBox(height: 4),
              Text('${(s.progress * 100).toStringAsFixed(0)}%'),
            ],
          );
        }
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: Icon(Icons.download),
            onPressed: () =>
                context.read<DownloadBloc>().add(DownloadRequested(image)),
            label: const Text('Download'),
          ),
        );
      },
    );
  }
}
