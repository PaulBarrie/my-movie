import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoView extends StatelessWidget {
  final String videoId;

  const VideoView({Key? key, required this.videoId}) : super(key: key);

  YoutubePlayerController _getController() {
    return YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayerScaffold(
        controller: _getController(),
        builder: (_, player) => player,
      ),
    );
  }
}
