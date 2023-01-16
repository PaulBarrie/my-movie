import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/custom_progress_indicator.dart';
import 'package:my_movie/components/empty_widget.dart';
import 'package:my_movie/components/movie_detail_grade.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/database_favourite_service.dart';
import 'package:my_movie/service/favourite_service.dart';
import 'package:my_movie/service/web_service.dart';

class MovieView extends StatefulWidget {
  final MoviePreview moviePreview;

  const MovieView({Key? key, required this.moviePreview}) : super(key: key);

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  MoviePreview get moviePreview => widget.moviePreview;

  late Movie movie;
  late FavouriteService favouriteService;
  late WebService webService;
  late Future<Movie> movieFuture;
  late bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    favouriteService = DatabaseFavouriteService();
    webService = APIWebService();
    movieFuture = moviePreview.mediaType == "movie"
        ? webService.getMovie(moviePreview.id)
        : webService.getTv(moviePreview.id);
    favouriteService.isFavourite(moviePreview.id).then((value) => setState(() {
          isFavourite = value;
        }));
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
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  String getFavouriteButtonText() {
    return isFavourite
        ? AppLocalizations.of(context)!.removeFromFavourites
        : AppLocalizations.of(context)!.addToFavourites;
  }

  Widget _getPoster(Movie movie) {
    if (movie.posterPath != null) {
      return Positioned.fill(
        child: Image.network(
          movie.posterPath!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const EmptyWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: movieFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            movie = snapshot.data!;
            String mediaOrigin = getMovieType(snapshot.data!.mediaType);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 250.0,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      _getPoster(movie),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              snapshot.data!.title,
                              style: Theme.of(context).textTheme.headline1,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 8,
                        ),
                        child: Center(
                          child: MovieDetailGrade(
                            votes: snapshot.data!.voteCount,
                            grade: (moviePreview.averageGrade / 2).round(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mediaOrigin,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            ElevatedButton(
                              onPressed: handleOnFavorite,
                              style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondary // Text Color
                                  ),
                              child: Text(getFavouriteButtonText()),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Synopsis",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data!.overview,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(
              child: CustomProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
