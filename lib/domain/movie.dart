

class Movie {
  final bool adult;
  final String imagePath;
  final String id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final String overview;
  final String posterPath;
  final String mediaType;
  final List<String> genreIds;
  final double popularity;
  final double averageGrade;
  final String releaseDate;
  final bool video;
  final int voteCount;
  final List<String> originCountry;
  Movie({
    required this.adult,
    required this.imagePath,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.averageGrade,
    required this.releaseDate,
    required this.video,
    required this.voteCount,
    required this.originCountry,
  });

  factory Movie.fromJson(Map<String, dynamic> json, String baseImageUrl) {
    final bool adult = (json['adult'].toString().toLowerCase() == "true");
    final bool video = (json['video'].toString().toLowerCase() == "true");
    final String imagePath = baseImageUrl + json['poster_path'];
    final String posterPath = baseImageUrl + json['poster_path'];

    return Movie(
      adult: adult,
      imagePath: imagePath,
      id: json['id'].toString(),
      title: json['name'].toString() == "null" ? json['title'].toString() : json['name'].toString(),
      originalTitle: json['original_name'].toString(),
      originalLanguage: json['original_language'].toString(),
      overview: json['overview'].toString(),
      posterPath: posterPath,
      mediaType: json['media_type'].toString(),
      genreIds: json['genre_ids'].toString().replaceAll("[", "").replaceAll("]", "").split(","),
      popularity: double.parse(json['popularity'].toString()),
      averageGrade: double.parse(json['vote_average'].toString()),
      releaseDate: json['release_date'].toString(),
      video: video,
      voteCount: int.parse(json['vote_count'].toString()),
      originCountry: json['origin_country'].toString().replaceAll("[", "").replaceAll("]", "").split(",")
    );
  }
}