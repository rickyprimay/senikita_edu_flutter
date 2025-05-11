import 'package:flutter/material.dart';
import 'package:widya/view/class_detail/widget/youtube_player_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LandscapeVideoWidget extends StatelessWidget {
  final YoutubePlayerController controller;

  const LandscapeVideoWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerWidget(
        controller: controller,
        isFullscreen: true,
      ),
    );
  }
}