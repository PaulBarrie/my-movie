import 'package:my_movie/domain/video.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/web_service.dart';

class VideoService {
  static final VideoService _instance = VideoService._internal();

  factory VideoService() => _instance;

  VideoService._internal();

  WebService get _webService => APIWebService();

  Future<List<Video>> getMovieVideos(String id) async {
    List<Video> videos = await _webService.getMovieVideos(id);
    return videos.where((video) => video.site == "YouTube").toList();
  }

  Future<List<Video>> getTvVideos(String id) async {
    List<Video> videos = await _webService.getTvVideos(id);
    return videos.where((video) => video.site == "YouTube").toList();
  }
}
