import 'movie.dart';

class MoviePreview {
  final String imagePath;
  final String id;
  final String title;
  final String overview;
  final double averageGrade;
  final int voteCount;

  MoviePreview(this.imagePath, this.id, this.title, this.overview,
      this.averageGrade, this.voteCount);

  MoviePreview.fromMovie(Movie movie)
      : imagePath = movie.imagePath,
        id = movie.id,
        title = movie.title,
        overview = movie.overview,
        averageGrade = movie.averageGrade,
        voteCount = movie.voteCount;

  Map<String, dynamic> toMap() => {
        'imagePath': imagePath,
        'id': id,
        'title': title,
        'overview': overview,
        'averageGrade': averageGrade,
        'voteCount': voteCount,
      };
}
