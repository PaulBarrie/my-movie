import 'package:flutter/material.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/web_service.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  WebService webService = APIWebService();

  @override
  Widget build(BuildContext context) {
    webService.search("avatar").then((value) => value.forEach((element) {
          print(element.title);
        }));
    return const Text("Search view");
  }
}
