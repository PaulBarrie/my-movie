

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class Config {
  final BuildContext context;
  final String configFileLocation = 'assets/config.json';
  String baseImageAPIURL = "";
  String apiBaseURL = "";
  String apiKey = "";
  
  Config({required this.context});


  Future<void> load(BuildContext context) async {
    final jsonString = await rootBundle.loadString('assets/config.json');
    final dynamic jsonMap = jsonDecode(jsonString);
    apiBaseURL = jsonMap['API_BASE_URL'];
    apiKey = jsonMap['API_KEY'];
    baseImageAPIURL = jsonMap['BASE_IMAGE_API_URL'];
  }

  Config get(BuildContext context) {
    return this;
  }

}