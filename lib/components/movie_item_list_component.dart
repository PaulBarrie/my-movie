

import 'package:flutter/material.dart';
import 'package:my_movie/components/grade_star.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../domain/movie.dart';

class MovieItemListComponent extends StatefulWidget {
  final Movie movie;
  const MovieItemListComponent({Key? key, required this.movie}) : super(key: key);
  
  @override
  State<MovieItemListComponent> createState() => _MovieItemListComponentState();
}

class _MovieItemListComponentState extends State<MovieItemListComponent> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie;
    String voteSentence = "${movie.voteCount} ${AppLocalizations.of(context)!.votes}";
    return Container(
      color: Colors.white70,
      child: Card(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            ListTile(
              leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(movie.imagePath),
                    fit: BoxFit.fill
                ),
              ),
            ),
              title: Text(movie.title),
              subtitle: Text(movie.overview),
            ),

           Row(
             mainAxisAlignment: MainAxisAlignment.center,

             children: <Widget>[
                GradeStar(value: movie.averageGrade.round()),
               const SizedBox(width: 50),
                Text(voteSentence),
               ],
           ),
         ],
      ),
    )
    );
  }
}
