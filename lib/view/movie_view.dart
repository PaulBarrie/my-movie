

import 'package:flutter/cupertino.dart';
import 'package:my_movie/domain/movie.dart';

class MovieView extends StatelessWidget {
  final Movie movie;
  const MovieView({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Movie View');
  }
}
