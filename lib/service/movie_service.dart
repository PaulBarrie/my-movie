import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_details.dart';
import 'package:my_movie/domain/video.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/video_service.dart';
import 'package:my_movie/service/web_service.dart';

class MovieService {
  Future<MovieDetails> getMovieDetails(String id, String mediaType) async {
    final WebService webService = APIWebService();
    final VideoService videoService = VideoService();
    Movie movie;
    List<Video> videos;
    if (mediaType == "movie") {
      movie = await webService.getMovie(id);
      videos = await videoService.getMovieVideos(id);
    } else {
      movie = await webService.getTv(id);
      videos = await videoService.getTvVideos(id);
    }
    return MovieDetails(movie, videos);
  }
}
