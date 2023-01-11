

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String configFileLocation = 'assets/config.json';
  String baseImageAPIURL = "";
  String apiBaseURL = "";
  String apiKey = "";
  
  Config();


  Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/config.json');
    final dynamic jsonMap = jsonDecode(jsonString);
    apiBaseURL = jsonMap['API_BASE_URL'];
    apiKey = jsonMap['API_KEY'];
    baseImageAPIURL = jsonMap['BASE_IMAGE_API_URL'];
  }

  Config get() {
    return this;
  }

}