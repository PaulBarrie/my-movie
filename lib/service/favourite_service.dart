import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';

abstract class FavouriteService {
  Future<List<MoviePreview>> getFavourites();

  Future<void> toggleFavourite(Movie movie);

  Future<void> addFavourite(Movie movie);

  Future<void> removeFavourite(Movie movie);

  Future<bool> isFavourite(String movieId);

  Future<void> clearFavourites();
}
