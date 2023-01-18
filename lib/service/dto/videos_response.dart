import 'package:my_movie/service/dto/video_response.dart';

class VideosResponse {
  final List<VideoResponse> results;

  VideosResponse({required this.results});

  factory VideosResponse.fromJson(Map<String, dynamic> json) {
    return VideosResponse(
      results: (json['results'] as List)
          .map((e) => VideoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
