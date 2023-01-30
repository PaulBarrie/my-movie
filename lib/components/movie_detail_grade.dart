import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:my_movie/components/grade_star.dart';

import '../view/reviews_view.dart';

class MovieDetailGrade extends StatelessWidget {
  final int votes;
  final int grade;
  final String category;
  final String id;

  const MovieDetailGrade({
    Key? key,
    required this.votes,
    required this.grade,
    required this.category,
    required this.id,
  }) : super(key: key);

  String _getSentence(BuildContext context) {
    String votesText = NumberFormat().format(votes);
    return "$votesText ${AppLocalizations.of(context)!.votes}";
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewsView(
              category: category,
              id: id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GradeStar(
              value: grade,
              size: 40,
            ),
            Text(
              _getSentence(context),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
