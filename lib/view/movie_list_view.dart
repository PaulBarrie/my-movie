import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/custom_progress_indicator.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/web_service.dart';

import '../components/movie_item_list_component.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({Key? key}) : super(key: key);

  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  late WebService webService;
  var search = "";
  late Future<List<Movie>> movieListFuture;

  @override
  void initState() {
    super.initState();
    webService = APIWebService();
    movieListFuture = webService.news(weekly: true);
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('movie-sliver-list');
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(AppLocalizations.of(context)!.movies),
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: movieListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return MovieItemListComponent(
                      moviePreview:
                          MoviePreview.fromMovie(snapshot.data![index]),
                    );
                  },
                  childCount: snapshot.data!.length,
                ),
              );
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Text("${snapshot.error}"),
              );
            }
            return const SliverToBoxAdapter(
              child: Center(
                child: CustomProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}
