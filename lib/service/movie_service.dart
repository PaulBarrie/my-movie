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
    final Movie movie = mediaType == "movie"
        ? await webService.getMovie(id)
        : await webService.getTv(id);
    final List<Video> videos = await videoService.getVideos(id);
    return MovieDetails(movie, videos);
  }
}
