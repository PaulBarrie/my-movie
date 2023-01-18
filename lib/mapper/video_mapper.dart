import 'package:my_movie/domain/video.dart';
import 'package:my_movie/service/dto/video_response.dart';

class VideoMapper {
  static Video fromDTO(VideoResponse videoResponse) {
    return Video(
      id: videoResponse.key,
      name: videoResponse.name,
      site: videoResponse.site,
      type: videoResponse.type,
    );
  }
}
