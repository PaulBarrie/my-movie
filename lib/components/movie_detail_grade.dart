import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:my_movie/components/grade_star.dart';

class MovieDetailGrade extends StatelessWidget {
  final int votes;
  final int grade;

  const MovieDetailGrade({Key? key, required this.votes, required this.grade})
      : super(key: key);

  String _getSentence(BuildContext context) {
    String votesText = NumberFormat().format(votes);
    return "$votesText ${AppLocalizations.of(context)!.votes}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
