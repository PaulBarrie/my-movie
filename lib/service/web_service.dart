import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/news.dart';

abstract class WebService {
  Future<List<Movie>> search(String search);

  Future<News> news({int page = 1, bool weekly = true});

  Future<Movie> getMovie(String id);

  Future<Movie> getTv(String id);
}
