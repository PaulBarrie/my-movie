import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/movie_item_list_component.dart';
import 'package:my_movie/domain/movie.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/web_service.dart';
import 'package:http/http.dart' as http;

import 'movie_view.dart';

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
    webService = APIWebService(context);
    movieListFuture = webService.news(weekly: true);
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('movie-sliver-list');
    return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.green,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppLocalizations.of(context)!.search),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieView(movie: snapshot.data![index]),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: MovieItemListComponent(movie:snapshot.data![index]),

                        ),
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
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ]
    );
  }
}
