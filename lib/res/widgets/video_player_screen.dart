import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final String? videoDescription;
  final String? videoContent;

  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    required this.videoTitle,
    this.videoDescription,
    this.videoContent,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _isFullScreen = orientation == Orientation.landscape;
        
        return WillPopScope(
          onWillPop: () async {
            if (_isFullScreen) {
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: _isFullScreen
                ? null
                : AppBar(
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.tertiary,
                          ],
                        ),
                      ),
                    ),
                    title: Text(
                      'Video Player',
                      style: AppFont.crimsonTextSubtitle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.tertiary.withAlpha(120),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: AppColors.primary,
                      progressColors: const ProgressBarColors(
                        playedColor: AppColors.primary,
                        handleColor: AppColors.tertiary,
                        backgroundColor: Colors.grey,
                        bufferedColor: Colors.white70,
                      ),
                      onReady: () {},
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        RemainingDuration(),
                        const PlaybackSpeedButton(),
                        FullScreenButton(
                          controller: _controller,
                        ),
                      ],
                      topActions: _isFullScreen
                          ? [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                  ]);
                                },
                              ),
                            ]
                          : null,
                    ),
                    builder: (context, player) {
                      return player;
                    },
                  ),
                  
                  if (!_isFullScreen) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.videoTitle,
                            style: AppFont.crimsonTextSubtitle.copyWith(
                              fontSize: 20,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.videoDescription ?? '',
                            style: AppFont.crimsonTextSubtitle.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.videoContent ?? '',
                            style: AppFont.crimsonTextSubtitle.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}