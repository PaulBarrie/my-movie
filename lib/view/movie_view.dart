import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/custom_progress_indicator.dart';
import 'package:my_movie/components/empty_widget.dart';
import 'package:my_movie/components/movie_detail_grade.dart';
import 'package:my_movie/components/video_list.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_details.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/service/database_favourite_service.dart';
import 'package:my_movie/service/favourite_service.dart';
import 'package:my_movie/service/movie_service.dart';

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
  late Future<MovieDetails> movieDetailsFuture;
  late bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    favouriteService = DatabaseFavouriteService();
    final MovieService movieService = MovieService();
    movieDetailsFuture =
        movieService.getMovieDetails(moviePreview.id, moviePreview.mediaType);
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
      body: FutureBuilder(
        future: movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            movie = snapshot.data!.movie;
            String mediaOrigin = getMovieType(movie.mediaType);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      movie.title,
                    ),
                    background: Stack(
                      children: [
                        _getPoster(movie),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                            votes: movie.voteCount,
                            grade: (moviePreview.averageGrade / 2).round(),
                            category: movie.mediaType,
                            id: movie.id,
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
                              style: Theme.of(context).textTheme.displaySmall,
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
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          movie.overview,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: VideoList(
                          videos: snapshot.data!.videos,
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
