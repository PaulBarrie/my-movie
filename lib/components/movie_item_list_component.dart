import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/grade_star.dart';
import 'package:my_movie/domain/movie_preview.dart';

import '../view/movie_view.dart';

class MovieItemListComponent extends StatefulWidget {
  final MoviePreview moviePreview;

  const MovieItemListComponent({Key? key, required this.moviePreview})
      : super(key: key);

  @override
  State<MovieItemListComponent> createState() => _MovieItemListComponentState();
}

class _MovieItemListComponentState extends State<MovieItemListComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MoviePreview moviePreview = widget.moviePreview;
    String voteSentence =
        "${moviePreview.voteCount} ${AppLocalizations.of(context)!.votes}";
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieView(
              moviePreview: moviePreview,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(moviePreview.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(moviePreview.title),
                subtitle: Text(moviePreview.overview),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GradeStar(value: (moviePreview.averageGrade / 2).round()),
                  const SizedBox(width: 50),
                  Text(voteSentence),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
