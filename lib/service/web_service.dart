
import 'package:http/http.dart' as http;
import '../domain/movie.dart';

abstract class WebService {
  Future<http.Response> search(String search);
  Future<List<Movie>> news({bool weekly = true});
  Future<http.Response> get(String id);
}