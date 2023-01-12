import '../domain/movie.dart';

abstract class WebService {
  Future<List<Movie>> search(String search);

  Future<List<Movie>> news({bool weekly = true});

  Future<Movie> getMovie(String id);

  Future<Movie> getTv(String id);
}
