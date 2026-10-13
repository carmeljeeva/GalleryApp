import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/fav/favorites_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/pages/detail_page.dart';
import 'package:project_gallery/features/gallery/presentation/widgets/image_tile.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesBloc, List<ImageModel>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const Center(child: Text('NO FAVs YET!'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final image = state[index];
                return ImageTile(
                  image: image,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(image: image),
                    ),
                  ),
                );
              },
              itemCount: state.length,
            ),
          );
        },
      ),
    );
  }
}
