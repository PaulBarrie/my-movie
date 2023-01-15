import 'package:flutter/material.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/view/movie_view.dart';

class SearchResultTile extends StatelessWidget {
  final Movie movie;

  const SearchResultTile({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(movie.title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieView(
                moviePreview: MoviePreview.fromMovie(movie),
              ),
            ),
          );
        });
  }
}
