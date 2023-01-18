import 'package:my_movie/domain/movie.dart';

class News {
  final int page;
  final int totalPages;
  final List<Movie> results;

  News({required this.page, required this.totalPages, required this.results});
}
