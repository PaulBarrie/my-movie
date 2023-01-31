class Movie {
  final String? imagePath;
  final String id;
  final String title;
  final String overview;
  final String? posterPath;
  final String mediaType;
  final double averageGrade;
  final int voteCount;

  Movie({
    required this.imagePath,
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.averageGrade,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json, String baseImageUrl,
      [String? mediaType]) {
    final String? imagePath =
        json['poster_path'] != null ? baseImageUrl + json['poster_path'] : null;
    final String? posterPath = imagePath;

    return Movie(
      imagePath: imagePath,
      id: json['id'].toString(),
      title: json['name'].toString() == "null"
          ? json['title'].toString()
          : json['name'].toString(),
      overview: json['overview'].toString(),
      posterPath: posterPath,
      mediaType: mediaType ?? json['media_type'].toString(),
      averageGrade: double.parse(json['vote_average'].toString()),
      voteCount: int.parse(json['vote_count'].toString()),
    );
  }
}
