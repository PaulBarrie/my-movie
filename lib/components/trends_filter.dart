import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/domain/news.dart';

import '../service/api_web_service.dart';
import '../service/web_service.dart';

class TrendsFilter extends StatefulWidget {
  final Function(News) onFilterSelected;
  final Function(String) onCategorySelected;

  const TrendsFilter({
    Key? key,
    required this.onFilterSelected,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<TrendsFilter> createState() => _TrendsFilterState();
}

class _TrendsFilterState extends State<TrendsFilter> {
  var choiceSelected = -1;
  late WebService webService;

  @override
  void initState() {
    super.initState();
    webService = APIWebService();
  }

  void _onSelected(bool isSelected) {
    if (!isSelected) {
      setState(() {
        choiceSelected = -1;
      });
    }
    _onSelectionChanged();
  }

  String _getCategory(int index) {
    switch (index) {
      case 0:
        return "movie";
      case 1:
        return "tv";
      default:
        return "all";
    }
  }

  Future<void> _onSelectionChanged() async {
    String category = _getCategory(choiceSelected);
    News news = await webService.news(
      filter: category,
      weekly: true,
      page: 1,
    );
    widget.onFilterSelected(news);
    widget.onCategorySelected(category);
  }

  @override
  Widget build(BuildContext context) {
    final choiceList = [
      AppLocalizations.of(context)!.movie,
      AppLocalizations.of(context)!.series
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < choiceList.length; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(choiceList[i]),
              selected: choiceSelected == i,
              onSelected: (selected) {
                choiceSelected = i;
                _onSelected(selected);
              },
              selectedColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
      ],
    );
  }
}
