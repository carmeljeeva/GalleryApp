import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';
import 'package:project_gallery/features/gallery/domain/usecases/image_usecases.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, List<ImageModel>> {
  final Togglefav togglefav;

  FavoritesBloc(GetFavorites getFavorites, this.togglefav)
    : super(getFavorites()) {
    on<FavoriteToggle>((event, emit) async {
      final newFavsImages = await togglefav.call(event.image);
      emit(newFavsImages);
    });
  }
}
