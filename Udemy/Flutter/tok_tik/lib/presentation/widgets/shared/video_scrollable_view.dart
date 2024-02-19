import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/presentation/widgets/video/fullscreen_player.dart';
import 'package:tok_tik/presentation/widgets/shared/video_buttons.dart';

class VideoScrollabelView extends StatelessWidget {
  final List<VideoPost> videos;

  const VideoScrollabelView({
    super.key,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final videoPost = videos[index];
        return Stack(
          children: [
            SizedBox.expand(
              child: FullScreenPlayer(
                videoUrl: videoPost.videoUrl,
                caption: videoPost.caption,
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: VideoButtons(video: videoPost),
            ),
          ],
        );
      },
    );
  }
}
