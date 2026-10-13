import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/fav/favorites_bloc.dart';

class ImageTile extends StatelessWidget {
  final ImageModel image;
  final VoidCallback? onTap;
  const ImageTile({super.key, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'img_${image.id}',
              child: CachedNetworkImage(
                imageUrl: image.imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 400,
                fadeInDuration: const Duration(milliseconds: 300),
                placeholder: (_, __) => ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (_, _, _) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: BlocSelector<FavoritesBloc, List<ImageModel>, bool>(
                selector: (fav) => fav.any((e) => e.id == image.id),
                builder: (context, fav) => IconButton.filled(
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      context.read<FavoritesBloc>().add(FavoriteToggle(image)),
                  icon: Icon(
                    fav ? Icons.favorite : Icons.favorite_border_rounded,
                    color: fav ? Colors.red : null,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
