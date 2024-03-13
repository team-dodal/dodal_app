import 'package:dodal_app/src/common/model/comment_model.dart';
import 'package:dodal_app/src/common/utils/dio.dart';
import 'package:dodal_app/src/common/model/feed_content_model.dart';

class FeedRepository {
  static final service = dio();

  static Future<List<FeedContent>> getAllFeeds({
    required int page,
    required int pageSize,
  }) async {
    final res =
        await service.get('/api/v1/feeds?page=$page&page_size=$pageSize');
    List<dynamic> contents = res.data['result']['content'];
    List<FeedContent> result =
        contents.map((content) => FeedContent.fromJson(content)).toList();
    return result;
  }

  static Future<List<FeedContent>> getFeedsByRoomId({
    required int page,
    required int pageSize,
    required int roomId,
  }) async {
    final res = await service
        .get('/api/v1/feeds/$roomId?page=$page&page_size=$pageSize');
    List<dynamic> contents = res.data['result']['content'];
    List<FeedContent> result =
        contents.map((content) => FeedContent.fromJson(content)).toList();
    return result;
  }

  static Future<FeedContent> getOneFeedById({
    required int feedId,
  }) async {
    final res = await service.get('/api/v1/feed/$feedId');
    return FeedContent.fromJson(res.data['result']);
  }

  static Future<void> feedLike({
    required int feedId,
    required bool value,
  }) async {
    if (value) {
      await service.post('/api/v1/like/$feedId');
    } else {
      await service.delete('/api/v1/like/$feedId');
    }
  }

  static getAllComments({
    required int feedId,
  }) async {
    final res = await service.get('/api/v1/comments/$feedId');
    return (res.data['result'] as List)
        .map((content) => Comment.fromJson(content))
        .toList();
  }

  static Future<List<Comment>> createComment({
    required int feedId,
    required String content,
    int? parentId,
  }) async {
    final data = {"parent_id": parentId, "content": content};

    final res = await service.post('/api/v1/comments/$feedId', data: data);
    List<dynamic> contents = res.data['result'];
    return contents.map((content) => Comment.fromJson(content)).toList();
  }

  static Future<List<Comment>> removeComment({
    required int feedId,
    required int commentId,
  }) async {
    final res = await service.delete('/api/v1/comments/$feedId', data: {
      "comment_id": commentId,
    });
    List<dynamic> contents = res.data['result'];
    return contents.map((content) => Comment.fromJson(content)).toList();
  }
}
