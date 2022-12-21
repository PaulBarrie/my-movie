

import 'package:http/src/response.dart';
import 'package:my_movie/kernel/config.dart';
import 'package:my_movie/service/dto/favorites_dto.dart';
import 'package:my_movie/service/web_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../domain/movie.dart';
import 'dart:async';
import 'dart:convert';

class APIWebService extends WebService {
  final BuildContext context;


  APIWebService(this.context);

  Future<Config> getConfig() async {
     Config config = Config(context: context);
     await config.load(context);
     return Future(() => config.get(context));
  }

  @override
  Future<Response> get(String id) async {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> news({bool weekly = true}) async {
    Config config = await getConfig();
    String frequency = weekly ? "week": "day";
    final response = await http.get(Uri.parse('${config.apiBaseURL}/trending/all/$frequency?api_key=${config.apiKey}'));
    if (response.statusCode == 200) {
      return FavoritesDTO.fromJson(jsonDecode(response.body), config.baseImageAPIURL).getResults();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load favorites movies.');
    }
  }

  @override
  Future<Response> search(String search) {
    // TODO: implement search
    throw UnimplementedError();
  }

}