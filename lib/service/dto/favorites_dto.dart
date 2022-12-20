

import '../../domain/movie.dart';

class FavoritesDTO {
  final int page;
  final List<Movie> results;

  FavoritesDTO({required this.page, required this.results});

  List<Movie> getResults() => results;
  factory FavoritesDTO.fromJson(Map<String, dynamic> json, String baseImageUrl) {
    return FavoritesDTO(
      page: json['page'],
      results: (json['results'] as List).map((e) => Movie.fromJson(e as Map<String, dynamic>, baseImageUrl)).toList(),
    );
  }
}