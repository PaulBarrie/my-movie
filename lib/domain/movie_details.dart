import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/video.dart';

class MovieDetails {
  final Movie movie;
  final List<Video> videos;

  MovieDetails(this.movie, this.videos);
}
