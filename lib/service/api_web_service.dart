import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_movie/kernel/config.dart';
import 'package:my_movie/service/dto/favorites_dto.dart';
import 'package:my_movie/service/web_service.dart';

import '../domain/movie.dart';

class APIWebService extends WebService {
  Future<Config> getConfig() async {
    Config config = Config();
    await config.load();
    return Future(() => config.get());
  }

  @override
  Future<List<Movie>> news({bool weekly = true}) async {
    Config config = await getConfig();
    String frequency = weekly ? "week" : "day";
    final response = await http.get(Uri.parse(
        '${config.apiBaseURL}/trending/all/$frequency?api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      return FavoritesDTO.fromJson(
              jsonDecode(response.body), config.baseImageAPIURL)
          .getResults();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load favorites movies.');
    }
  }

  @override
  Future<Movie?> get(String id) async {
    return null;
  }

  @override
  Future<List<Movie>> search(String search) async {
    return [];
  }
}
