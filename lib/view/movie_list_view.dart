import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/custom_progress_indicator.dart';
import 'package:my_movie/components/custom_search_delegate.dart';
import 'package:my_movie/components/empty_widget.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/domain/news.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/web_service.dart';

import '../components/movie_item_list_component.dart';
import '../components/trends_filter.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({Key? key}) : super(key: key);

  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  final SCROLL_LOADING_LIMIT = 200;

  late WebService webService;
  var search = "";
  var category = "all";
  late Future<News> newsFuture;
  final List<Movie> movies = [];
  int page = 0;
  late int totalPages;
  bool isLoading = false;
  final _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    webService = APIWebService();
    newsFuture = webService.news(weekly: true);
    _mainScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (page > 0 &&
        _mainScrollController.position.pixels >
            _mainScrollController.position.maxScrollExtent -
                SCROLL_LOADING_LIMIT) {
      if (page < totalPages) {
        setState(() {
          loadMoreMovies();
        });
      }
    }
  }

  _filterMovies(News news) {
    setState(() {
      movies.clear();
      loadMovies(news);
    });
  }

  _updateCategory(String category) {
    setState(() {
      this.category = category;
    });
  }

  void loadMovies(News news) {
    page = news.page;
    totalPages = news.totalPages;
    movies.addAll(news.results);
  }

  Future<void> loadMoreMovies() async {
    if (!isLoading && page < totalPages) {
      setState(() {
        isLoading = true;
      });
      News news =
          await webService.news(filter: category, weekly: true, page: page + 1);
      loadMovies(news);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget getLoadComponent() {
    if (isLoading) {
      return const CustomProgressIndicator();
    } else {
      return const EmptyWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('movie-sliver-list');
    return CustomScrollView(
      controller: _mainScrollController,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: true,
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: Text(
                  AppLocalizations.of(context)!.trends,
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              background: TrendsFilter(
                onFilterSelected: _filterMovies,
                onCategorySelected: _updateCategory,
              ),
            );
          }),
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
                    if (index < movies.length) {
                      return MovieItemListComponent(
                        moviePreview: MoviePreview.fromMovie(movies[index]),
                      );
                    }
                    return Center(
                      child: getLoadComponent(),
                    );
                  },
                  childCount: movies.length + 1,
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
