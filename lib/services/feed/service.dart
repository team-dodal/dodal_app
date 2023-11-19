import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/feed/response.dart';

class FeedService {
  static Future<List<FeedContentResponse>?> getAllFeeds({
    required int page,
    required int pageSize,
  }) async {
    try {
      final service = dio();
      final res =
          await service.get('/api/v1/feeds?page=$page&page_size=$pageSize');
      List<dynamic> contents = res.data['result']['content'];
      List<FeedContentResponse> result = contents
          .map((content) => FeedContentResponse.fromJson(content))
          .toList();
      return result;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<List<FeedContentResponse>?> getFeedsByRoomId({
    required int page,
    required int pageSize,
    required int roomId,
  }) async {
    try {
      final service = dio();
      final res = await service
          .get('/api/v1/feeds/$roomId?page=$page&page_size=$pageSize');
      List<dynamic> contents = res.data['result']['content'];
      List<FeedContentResponse> result = contents
          .map((content) => FeedContentResponse.fromJson(content))
          .toList();
      return result;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<FeedContentResponse?> getOneFeedById({
    required int feedId,
  }) async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/feed/$feedId');
      return FeedContentResponse.fromJson(res.data['result']);
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
      final service = dio();
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
}
