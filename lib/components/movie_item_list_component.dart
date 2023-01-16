import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/empty_widget.dart';
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

  Widget _getTileHeader(MoviePreview moviePreview) {
    if (moviePreview.imagePath != null) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(moviePreview.imagePath!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const EmptyWidget();
    }
  }

  void _handleOnTap(MoviePreview moviePreview) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieView(
          moviePreview: moviePreview,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MoviePreview moviePreview = widget.moviePreview;
    String voteSentence =
        "${moviePreview.voteCount} ${AppLocalizations.of(context)!.votes}";

    return ListTile(
      onTap: () => _handleOnTap(moviePreview),
      leading: _getTileHeader(moviePreview),
      title: Text(moviePreview.title),
      subtitle: Text(voteSentence),
      trailing: GradeStar(
        value: (moviePreview.averageGrade / 2).round(),
      ),
    );
  }
}
