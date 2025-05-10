import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:widya/res/widgets/colors.dart';

class YoutubePlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final bool isFullscreen;

  const YoutubePlayerWidget({
    Key? key,
    required this.controller,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.tertiary,
        ),
      ),
      builder: (context, player) {
        if (isFullscreen) {
          return Center(child: player);
        }
        return Column(
          children: [player],
        );
      },
    );
  }
}