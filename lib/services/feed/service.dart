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
      List<FeedContentResponse> result =
          contents.map((e) => FeedContentResponse.fromJson(contents)).toList();
      return result;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }
}
