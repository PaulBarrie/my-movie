import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/custom_progress_indicator.dart';
import 'package:my_movie/components/custom_search_delegate.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/domain/news.dart';
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
  late Future<News> newsFuture;
  final List<Movie> movies = [];
  int page = 0;
  late int totalPages;

  @override
  void initState() {
    super.initState();
    webService = APIWebService();
    newsFuture = webService.news(weekly: true);
  }

  void loadMovies(News news) {
    page = news.page;
    totalPages = news.totalPages;
    movies.addAll(news.results);
  }

  void loadMoreMovies() async {
    if (page < totalPages) {
      News news = await webService.news(weekly: true, page: page + 1);
      loadMovies(news);
      setState(() {});
    }
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
            title: Text(AppLocalizations.of(context)!.trends),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        FutureBuilder<News>(
          future: newsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (page == 0) {
                loadMovies(snapshot.data!);
              }
              return SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return MovieItemListComponent(
                      moviePreview: MoviePreview.fromMovie(movies[index]),
                    );
                  },
                  childCount: movies.length,
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
        SliverToBoxAdapter(
          child: Center(
            child: TextButton(
              onPressed: loadMoreMovies,
              child: const Text("Load more"),
            ),
          ),
        ),
      ],
    );
  }
}
