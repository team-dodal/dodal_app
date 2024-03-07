import 'package:dio/dio.dart';
import 'package:dodal_app/src/common/model/comment_model.dart';
import 'package:dodal_app/src/common/repositories/common/error_dialog.dart';
import 'package:dodal_app/src/common/repositories/common/main.dart';
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

  static Future<List<FeedContent>?> getFeedsByRoomId({
    required int page,
    required int pageSize,
    required int roomId,
  }) async {
    try {
      final res = await service
          .get('/api/v1/feeds/$roomId?page=$page&page_size=$pageSize');
      List<dynamic> contents = res.data['result']['content'];
      List<FeedContent> result =
          contents.map((content) => FeedContent.fromJson(content)).toList();
      return result;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<FeedContent?> getOneFeedById({
    required int feedId,
  }) async {
    try {
      final res = await service.get('/api/v1/feed/$feedId');
      return FeedContent.fromJson(res.data['result']);
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<bool?> feedLike({
    required int feedId,
    required bool value,
  }) async {
    try {
      if (value) {
        await service.post('/api/v1/like/$feedId');
        return true;
      } else {
        await service.delete('/api/v1/like/$feedId');
        return false;
      }
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static getAllComments({
    required int feedId,
  }) async {
    try {
      final res = await service.get('/api/v1/comments/$feedId');

      List<dynamic> contents = res.data['result'];
      return contents
          .map((content) => CommentResponse.fromJson(content))
          .toList();
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<List<CommentResponse>> createComment({
    required int feedId,
    required String content,
    int? parentId,
  }) async {
    try {
      final data = {"parent_id": parentId, "content": content};

      final res = await service.post('/api/v1/comments/$feedId', data: data);
      List<dynamic> contents = res.data['result'];
      return contents
          .map((content) => CommentResponse.fromJson(content))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  static removeComment({
    required int feedId,
    required int commentId,
  }) async {
    try {
      final res = await service.delete('/api/v1/comments/$feedId', data: {
        "comment_id": commentId,
      });
      List<dynamic> contents = res.data['result'];
      return contents
          .map((content) => CommentResponse.fromJson(content))
          .toList();
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }
}
