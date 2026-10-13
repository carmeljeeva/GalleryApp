part of 'favorites_bloc.dart';

class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class FavoriteToggle extends FavoritesEvent {
  final ImageModel image;
  const FavoriteToggle(this.image);
}
