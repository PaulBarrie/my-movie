import '../../domain/movie.dart';

class NewsResponse {
  final int page;
  final int totalPages;
  final List<Movie> results;

  NewsResponse(
      {required this.page, required this.totalPages, required this.results});

  factory NewsResponse.fromJson(
      Map<String, dynamic> json, String baseImageUrl) {
    return NewsResponse(
      page: json['page'],
      totalPages: json['total_pages'],
      results: (json['results'] as List)
          .map((e) {
            try {
              return Movie.fromJson(e as Map<String, dynamic>, baseImageUrl);
            } catch (_) {
              return null;
            }
          })
          .whereType<Movie>()
          .toList(),
    );
  }
}
