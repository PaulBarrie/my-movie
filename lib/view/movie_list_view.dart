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
  static const _SCROLL_LOADING_LIMIT = 200;

  late WebService _webService;
  var _category = "all";
  late Future<News> _newsFuture;
  final List<Movie> _movies = [];
  int _page = 0;
  late int _totalPages;
  bool _isLoading = false;
  final _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _webService = APIWebService();
    _newsFuture = _webService.news(weekly: true);
    _mainScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_page > 0 &&
        _mainScrollController.position.pixels >
            _mainScrollController.position.maxScrollExtent -
                _SCROLL_LOADING_LIMIT) {
      if (_page < _totalPages) {
        setState(() {
          _loadMoreMovies();
        });
      }
    }
  }

  void _filterMovies(News news) {
    setState(() {
      _movies.clear();
      _loadMovies(news);
    });
  }

  void _updateCategory(String category) {
    setState(() {
      _category = category;
    });
  }

  void _loadMovies(News news) {
    _page = news.page;
    _totalPages = news.totalPages;
    _movies.addAll(news.results);
  }

  Future<void> _loadMoreMovies() async {
    if (!_isLoading && _page < _totalPages) {
      setState(() {
        _isLoading = true;
      });
      News news = await _webService.news(
          filter: _category, weekly: true, page: _page + 1);
      _loadMovies(news);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _getLoadComponent() {
    if (_isLoading) {
      return const CustomProgressIndicator();
    } else {
      return const EmptyWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_page == 0) {
                _loadMovies(snapshot.data!);
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index < _movies.length) {
                      return MovieItemListComponent(
                        moviePreview: MoviePreview.fromMovie(_movies[index]),
                      );
                    }
                    return Center(
                      child: _getLoadComponent(),
                    );
                  },
                  childCount: _movies.length + 1,
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
