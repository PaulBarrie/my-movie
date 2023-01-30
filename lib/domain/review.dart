class Review {
  final String username;
  final String content;
  final String date;
  final double? rating;
  final String? image;

  Review({
    required this.username,
    required this.content,
    required this.date,
    required this.rating,
    required this.image,
  });

  factory Review.fromJson(Map<String, dynamic> json, String baseImageUrl) {
    final user = json["author_details"];
    final String? image = _getImage(baseImageUrl, user["avatar_path"]);
    return Review(
      username: json['author'],
      content: json['content'],
      date: json['created_at'],
      rating: user['rating'],
      image: image,
    );
  }

  static String? _getImage(String baseImageUrl, String? image) {
    if (image == null) {
      return null;
    }
    if(image.startsWith("/http")) {
      return image.substring(1);
    }
    return baseImageUrl + image;
  }
}
