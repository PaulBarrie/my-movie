import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/news.dart';
import 'package:my_movie/domain/video.dart';
import 'package:my_movie/kernel/config.dart';
import 'package:my_movie/mapper/news_mapper.dart';
import 'package:my_movie/mapper/video_mapper.dart';
import 'package:my_movie/service/dto/news_response.dart';
import 'package:my_movie/service/dto/videos_response.dart';
import 'package:my_movie/service/web_service.dart';

class APIWebService extends WebService {
  static final APIWebService _singleton = APIWebService._internal();

  factory APIWebService() {
    return _singleton;
  }

  APIWebService._internal();

  Future<Config> getConfig() async {
    Config config = Config();
    await config.load();
    return Future(() => config.get());
  }

  @override
  Future<News> news({int page = 1, filter = "all", bool weekly = true}) async {
    Config config = await getConfig();
    String frequency = weekly ? "week" : "day";
    final response = await http.get(Uri.parse(
        '${config.apiBaseURL}/trending/$filter/$frequency?page=$page&api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      NewsResponse newsResponse = NewsResponse.fromJson(
          jsonDecode(response.body), config.baseImageAPIURL);
      return NewsMapper.fromDTO(newsResponse);
    } else {
      throw Exception('Failed to load favorites movies.');
    }
  }

  @override
  Future<Movie> getMovie(String id) async {
    Config config = await getConfig();
    final response = await http.get(
        Uri.parse('${config.apiBaseURL}/movie/$id?api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      return Movie.fromJson(
          jsonDecode(response.body), config.baseImageAPIURL, "movie");
    } else {
      throw Exception('Failed to load movie.');
    }
  }

  @override
  Future<Movie> getTv(String id) async {
    Config config = await getConfig();
    final response = await http
        .get(Uri.parse('${config.apiBaseURL}/tv/$id?api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      return Movie.fromJson(
          jsonDecode(response.body), config.baseImageAPIURL, "tv");
    } else {
      throw Exception('Failed to load tv.');
    }
  }

  @override
  Future<List<Movie>> search(String search) async {
    Config config = await getConfig();
    final response = await http.get(Uri.parse(
        '${config.apiBaseURL}/search/multi?query=$search&api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      return NewsResponse.fromJson(
          jsonDecode(response.body), config.baseImageAPIURL)
          .results;
    } else {
      throw Exception('Failed to search.');
    }
  }

  @override
  Future<List<Video>> getVideos(String id) async {
    Config config = await getConfig();
    final response = await http.get(Uri.parse(
        '${config.apiBaseURL}/movie/$id/videos?api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      return VideosResponse.fromJson(jsonDecode(response.body))
          .results
          .map(VideoMapper.fromDTO)
          .toList();
    } else {
      throw Exception('Failed to load videos.');
    }
  }
}
