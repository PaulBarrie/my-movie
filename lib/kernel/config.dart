import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String _configFileLocation = 'assets/config.json';
  String baseImageAPIURL = "";
  String apiBaseURL = "";
  String apiKey = "";

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(_configFileLocation);
    final dynamic jsonMap = jsonDecode(jsonString);
    apiBaseURL = jsonMap['API_BASE_URL'];
    apiKey = jsonMap['API_KEY'];
    baseImageAPIURL = jsonMap['BASE_IMAGE_API_URL'];
  }
}
