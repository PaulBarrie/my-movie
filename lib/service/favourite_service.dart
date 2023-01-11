import 'package:my_movie/domain/movie_preview.dart';

import '../domain/movie.dart';

abstract class FavouriteService {
  Future<List<MoviePreview>> getFavourites();

  Future<void> toggleFavourite(Movie movie);

  Future<void> addFavourite(Movie movie);

  Future<void> removeFavourite(Movie movie);

  Future<bool> isFavourite(Movie movie);

  Future<void> clearFavourites();
}
