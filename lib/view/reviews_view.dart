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

  get category => widget.category;

  get id => widget.id;

  late Future<Reviews> reviewsFuture;
  late WebService webService;
  final List<Review> reviews = [];
  int page = 0;
  late int totalPages;
  bool isLoading = false;
  final _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    webService = APIWebService();
    if (category == "movie") {
      reviewsFuture = webService.getMovieReviews(id: id);
    } else {
      reviewsFuture = webService.getTvReviews(id: id);
    }
    _mainScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (page > 0 &&
        _mainScrollController.position.pixels >
            _mainScrollController.position.maxScrollExtent -
                SCROLL_LOADING_LIMIT) {
      if (page < totalPages) {
        setState(() {
          loadMoreReviews();
        });
      }
    }
  }

  Future<void> loadMoreReviews() async {
    if (!isLoading && page < totalPages) {
      setState(() {
        isLoading = true;
      });
      Reviews reviews;
      if (category == "movie") {
        reviews = await webService.getMovieReviews(id: id, page: page + 1);
      } else {
        reviews = await webService.getTvReviews(id: id, page: page + 1);
      }
      loadReviews(reviews);
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadReviews(Reviews reviews) {
    page = reviews.page;
    totalPages = reviews.totalPages;
    this.reviews.addAll(reviews.results);
  }

  Widget getLoadComponent() {
    if (isLoading) {
      return const CustomProgressIndicator();
    } else {
      return const EmptyWidget();
    }
  }

  Widget? getLeading(String? imageUrl) {
    if (imageUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      );
    } else {
      return const Icon(Icons.person);
    }
  }

  //
  Widget getReviewTitle(String title, double? rating) {
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
        future: reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (page == 0) {
              loadReviews(snapshot.data!);
            }
            return ListView.separated(
              controller: _mainScrollController,
              itemCount: reviews.length + 1,
              itemBuilder: (context, index) {
                if (index < reviews.length) {
                  return ListTile(
                    leading: getLeading(reviews[index].image),
                    title: getReviewTitle(
                      reviews[index].username,
                      reviews[index].rating,
                    ),
                    subtitle: Text(reviews[index].content),
                  );
                } else {
                  return getLoadComponent();
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
