import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/components/empty_widget.dart';
import 'package:my_movie/domain/video.dart';
import 'package:my_movie/view/video_view.dart';

class VideoList extends StatefulWidget {
  final List<Video> videos;

  const VideoList({Key? key, required this.videos}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  bool allDisplayed = false;

  get videos => widget.videos;

  List<Widget> _getVideoList(BuildContext context) {
    List<Widget> videoList = [];
    for (int i = 0; i < videos.length; i++) {
      if (i < 3 || allDisplayed) {
        videoList.add(_getVideoItem(videos[i], context));
      }
    }
    if (videos.length > 3 && !allDisplayed) {
      videoList.add(_getSeeAllButton());
    }
    return videoList;
  }

  Widget _getVideoItem(Video video, BuildContext context) {
    return ListTile(
      onTap: () => _handleOnTap(video, context),
      leading: Icon(
        Icons.play_arrow,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      title: Text(
        video.name,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      subtitle: Text(
        video.type,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  void _handleOnTap(Video video, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoView(
          videoId: video.id,
        ),
      ),
    );
  }

  Widget _getSeeAllButton() {
    return TextButton(
      onPressed: () => setState(() {
        allDisplayed = true;
      }),
      child: Text(
        AppLocalizations.of(context)!.seeAll,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const EmptyWidget();
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: _getVideoList(context),
      ),
    );
  }
}
