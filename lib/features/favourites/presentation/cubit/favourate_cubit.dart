import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:postly_application/features/favourites/domain/usecases/get_favourates.dart';
import 'package:postly_application/features/favourites/domain/usecases/remove_favourate.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/repositaries/post_reprositary.dart';

part 'favourate_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final RemoveFavorite removeFavoriteUsecase;

  FavoritesCubit({
    required this.getFavorites,
    required this.removeFavoriteUsecase,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    try {
      emit(FavoritesLoading());
      final favorites = await getFavorites.call();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> removeFavorite(Post post) async {
    try {
      await removeFavoriteUsecase.call(post);
      final favorites = await getFavorites.call();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }
}
