import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/movie_item_list_component.dart';
import 'package:my_movie/domain/movie_preview.dart';
import 'package:my_movie/service/database_favourite_service.dart';
import 'package:my_movie/service/favourite_service.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  late FavouriteService favouriteService;
  late Future<List<MoviePreview>> moviePreviewListFuture;

  @override
  void initState() {
    super.initState();
    favouriteService = DatabaseFavouriteService();
    moviePreviewListFuture = favouriteService.getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favourites),
      ),
      body: FutureBuilder<List<MoviePreview>>(
        future: moviePreviewListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MovieItemListComponent(
                  moviePreview: snapshot.data![index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
