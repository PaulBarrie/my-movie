import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/news.dart';
import 'package:my_movie/domain/reviews.dart';
import 'package:my_movie/domain/video.dart';

abstract class WebService {
  Future<List<Movie>> search(String search);

  Future<News> news({int page = 1, filter = "all", bool weekly = true});

  Future<Movie> getMovie(String id);

  Future<Movie> getTv(String id);

  Future<List<Video>> getMovieVideos(String id);

  Future<List<Video>> getTvVideos(String id);

  Future<Reviews> getMovieReviews({required String id, int page = 1});

  Future<Reviews> getTvReviews({required String id, int page = 1});
}
