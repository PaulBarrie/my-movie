import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/custom_progress_indicator.dart';
import 'package:my_movie/components/empty_widget.dart';
import 'package:my_movie/components/grade_star.dart';
import 'package:my_movie/domain/review.dart';
import 'package:my_movie/domain/reviews.dart';
import 'package:my_movie/service/api_web_service.dart';
import 'package:my_movie/service/web_service.dart';

class ReviewsView extends StatefulWidget {
  final String category;
  final String id;

  const ReviewsView({Key? key, required this.category, required this.id})
      : super(key: key);

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  static const SCROLL_LOADING_LIMIT = 200;

  get _category => widget.category;

  get _id => widget.id;

  late Future<Reviews> _reviewsFuture;
  late WebService _webService;
  final List<Review> _reviews = [];
  int _page = 0;
  late int _totalPages;
  bool _isLoading = false;
  final _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _webService = APIWebService();
    if (_category == "movie") {
      _reviewsFuture = _webService.getMovieReviews(id: _id);
    } else {
      _reviewsFuture = _webService.getTvReviews(id: _id);
    }
    _mainScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_page > 0 &&
        _mainScrollController.position.pixels >
            _mainScrollController.position.maxScrollExtent -
                SCROLL_LOADING_LIMIT) {
      if (_page < _totalPages) {
        setState(() {
          _loadMoreReviews();
        });
      }
    }
  }

  Future<void> _loadMoreReviews() async {
    if (!_isLoading && _page < _totalPages) {
      setState(() {
        _isLoading = true;
      });
      Reviews reviews;
      if (_category == "movie") {
        reviews = await _webService.getMovieReviews(id: _id, page: _page + 1);
      } else {
        reviews = await _webService.getTvReviews(id: _id, page: _page + 1);
      }
      _loadReviews(reviews);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadReviews(Reviews reviews) {
    _page = reviews.page;
    _totalPages = reviews.totalPages;
    _reviews.addAll(reviews.results);
  }

  Widget _getLoadComponent() {
    if (_isLoading) {
      return const CustomProgressIndicator();
    } else {
      return const EmptyWidget();
    }
  }

  Widget? _getLeading(String? imageUrl) {
    if (imageUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      );
    } else {
      return const Icon(Icons.person);
    }
  }

  //
  Widget _getReviewTitle(String title, double? rating) {
    if (rating != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          GradeStar(value: (rating / 2).round()),
        ],
      );
    } else {
      return Text(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reviews),
      ),
      body: FutureBuilder<Reviews>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_page == 0) {
              _loadReviews(snapshot.data!);
            }
            return ListView.separated(
              controller: _mainScrollController,
              itemCount: _reviews.length + 1,
              itemBuilder: (context, index) {
                if (index < _reviews.length) {
                  return ListTile(
                    leading: _getLeading(_reviews[index].image),
                    title: _getReviewTitle(
                      _reviews[index].username,
                      _reviews[index].rating,
                    ),
                    subtitle: Text(_reviews[index].content),
                  );
                } else {
                  return _getLoadComponent();
                }
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}",
                style: const TextStyle(color: Colors.black));
          }
          return const Center(
            child: CustomProgressIndicator(),
          );
        },
      ),
    );
  }
}
