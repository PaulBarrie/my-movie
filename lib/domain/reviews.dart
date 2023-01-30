import 'package:my_movie/domain/review.dart';

class Reviews {
  final int page;
  final int totalPages;
  final List<Review> results;

  Reviews(
      {required this.page, required this.totalPages, required this.results});

  factory Reviews.fromJson(Map<String, dynamic> json, String baseImageUrl) {
    var list = json['results'] as List;
    List<Review> reviewsList = list.map((i) => Review.fromJson(i, baseImageUrl)).toList();
    return Reviews(
      page: json['page'],
      totalPages: json['total_pages'],
      results: reviewsList,
    );
  }
}
