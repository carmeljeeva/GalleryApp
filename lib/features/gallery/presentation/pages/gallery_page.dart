import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_event.dart';
import 'package:project_gallery/features/gallery/presentation/bloc/gallery_state.dart';
import 'package:project_gallery/features/gallery/presentation/pages/detail_page.dart';
import 'package:project_gallery/features/gallery/presentation/pages/favorites_page.dart';
import 'package:project_gallery/features/gallery/presentation/widgets/error_widget.dart';
import 'package:project_gallery/features/gallery/presentation/widgets/image_tile.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 400) {
        context.read<GalleryBloc>().add(GalleryNxtPageRequested());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final bloc = context.read<GalleryBloc>()..add(GalleryRefreshed());
    await bloc.stream.firstWhere((s) => s.status != GalleryStatus.loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesPage()),
            ),
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state.status == GalleryStatus.initial ||
              state.status == GalleryStatus.loading && state.images.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.status == GalleryStatus.failure) {
            // return SizedBox.shrink();
            return ErrorView(
              message: state.error ?? 'something went wrong',
              onRetry: () => context.read<GalleryBloc>().add(GalleryStarted()),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      maxCrossAxisExtent: 200,
                    ),
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      final image = state.images[index];
                      return ImageTile(
                        image: image,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(image: image),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(child: Footer(state: state)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final GalleryState state;
  const Footer({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.loadingMore) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.error != null) {
      return ErrorView(
        compact: true,
        message: state.error!,
        onRetry: () =>
            context.read<GalleryBloc>().add(GalleryNxtPageRequested()),
      );
    }
    if (state.hasReachedMax) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Center(child: Text('No more images')),
      );
    }
    return const SizedBox(height: 25);
  }
}
