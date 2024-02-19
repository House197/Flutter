import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/models/local_video_model.dart';
import 'package:tok_tik/shared/data/local_videos_post.dart';

class DiscoverProvider extends ChangeNotifier {
  bool initialLoading = true;
  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    final List<VideoPost> newVideos = videoPosts
        .map((video) => LocalVideoModel.fromJsonMap(video).toVideoPostEntity())
        .toList();

    videos.addAll(newVideos);
    initialLoading = false;
    notifyListeners();
  }
}
