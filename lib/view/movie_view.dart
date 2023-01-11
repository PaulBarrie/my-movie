import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/country_emoji.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/service/database_favourite_service.dart';
import 'package:my_movie/service/favourite_service.dart';

import '../components/grade_star.dart';

class MovieView extends StatefulWidget {
  final Movie movie;

  const MovieView({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  late Movie movie;
  late FavouriteService favouriteService;

  @override
  void initState() {
    super.initState();
    favouriteService = DatabaseFavouriteService();
    movie = widget.movie;
  }

  String getMovieType(String mediaType) {
    return mediaType == "tv"
        ? AppLocalizations.of(context)!.tvShow
        : mediaType == "movie"
            ? AppLocalizations.of(context)!.movie
            : AppLocalizations.of(context)!.series;
  }

  void handleOnFavorite() async {
    await favouriteService.toggleFavourite(movie);
  }

  @override
  Widget build(BuildContext context) {
    String mediaOrigin =
        '${CountryEmoji().get(movie.originalLanguage)} ${getMovieType(movie.mediaType)}';
    String nbVotesSentence =
        "${movie.voteCount} ${AppLocalizations.of(context)!.votes}";
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white24,
          expandedHeight: 250.0,
          flexibleSpace: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(movie.imagePath),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.white12,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mediaOrigin),
                    Column(
                      children: [
                        GradeStar(value: movie.averageGrade.round()),
                        Text(nbVotesSentence),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: handleOnFavorite,
                child: const Text("Favourite"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
