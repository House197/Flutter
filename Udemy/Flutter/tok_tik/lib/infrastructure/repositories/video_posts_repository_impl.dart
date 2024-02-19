import 'package:tok_tik/domain/datasources/video_posts_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';

class VideoPostsRepositoryImpl extends VideoPostRepository {
  // Se usa la clase abstracta de VideoPostDatasource, no la implementación.
  // Eso implica que cualquier VideoPostDatasource es permitido.
  final VideoPostDatasource videosDatasource;

  VideoPostsRepositoryImpl({required this.videosDatasource});

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return videosDatasource.getTrendingVideosByPage(page);
  }
}
