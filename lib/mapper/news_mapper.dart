import 'package:my_movie/domain/news.dart';
import 'package:my_movie/service/dto/news_response.dart';

class NewsMapper {
  static News fromDTO(NewsResponse newsResponse) {
    return News(
        page: newsResponse.page,
        totalPages: newsResponse.totalPages,
        results: newsResponse.results);
  }
}
