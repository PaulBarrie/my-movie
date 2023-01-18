class VideoResponse {
  final String name;
  final String key;
  final String type;
  final String site;

  VideoResponse(
      {required this.name,
      required this.key,
      required this.type,
      required this.site});

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      name: json['name'],
      key: json['key'],
      type: json['type'],
      site: json['site'],
    );
  }
}
