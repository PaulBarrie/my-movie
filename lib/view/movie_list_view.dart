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

class MovieListView extends StatefulWidget {
  const MovieListView({Key? key}) : super(key: key);

  @override
  State<MovieListView> createState() => _MovieListViewState();
}


class _MovieListViewState extends State<MovieListView> {
  final SCROLL_LOADING_LIMIT = 200;

  late WebService webService;
  var search = "";
  var choiceSelected = 999;
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
    newsFuture = webService.news(filter: choiceSelectionKeyMap(choiceSelected), weekly: true);
    choiceSelected = 999;
    _mainScrollController.addListener(_onScroll);
  }
  String choiceSelectionKeyMap(int index) {
    print("index: $index");
    switch (index) {
      case 0:
        print("movie");
        return "movie";
      case 1:
        print("tv");
        return "tv";
      default:
        print("all");
        return "all";
    }
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

  Future<void> onSelectionChanged(int index) async{
    setState(()  {
      choiceSelected = index;
      search = "";
      movies.clear();
      page = 0;
    });
    News news = await webService.news(filter: choiceSelectionKeyMap(choiceSelected), weekly: true, page: page + 1);
    print(news.results);
    setState(() {
      loadMovies(news);
    });

  }

  void loadMovies(News news) {
    page = news.page;
    totalPages = news.totalPages;
    movies.addAll(news.results);
  }

  Future<void> loadMoreMovies({String filter = "all"}) async {
    if (!isLoading && page < totalPages) {
      setState(() {
        isLoading = true;
      });
      News news = await webService.news(filter: choiceSelectionKeyMap(choiceSelected), weekly: true, page: page + 1);
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
    var choiceList = [
        AppLocalizations.of(context)!.movie,
        AppLocalizations.of(context)!.tvShow
    ];

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
                  // print('constraints=' + constraints.toString());
                  return FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          //opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                          opacity: 1.0,
                          child: Text(
                            AppLocalizations.of(context)!.trends,
                            style: const TextStyle(fontSize: 20.0),
                          )),
                      background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for(int i=0; i < choiceList.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text(choiceList[i]),
                                  selected: choiceSelected == i,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      choiceSelected = selected ? i : 999;
                                      onSelectionChanged(choiceSelected);
                                    });
                                  },
                                  selectedColor: Colors.green,
                                ),
                              )
                            ]
                          )
                  );
                }
            ),
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
