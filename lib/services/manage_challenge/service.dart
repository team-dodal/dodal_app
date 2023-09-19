import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';

class ManageChallengeService {
  static Future<List<JoinedChallengesResponse>?> joinedChallenges() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/users/me/challenges/user');
      List<dynamic> result = res.data['result'];
      List<JoinedChallengesResponse> list = result
          .map((item) => JoinedChallengesResponse.fromJson(item))
          .toList();
      return list;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<List<HostChallengesResponse>?> hostChallenges() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/users/me/challenges/host');
      List<dynamic> result = res.data['result'];
      List<HostChallengesResponse> list =
          result.map((item) => HostChallengesResponse.fromJson(item)).toList();
      return list;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<Map<String, List<FeedItem>>?> getCertificationList({
    required int roomId,
    required String dateYM,
  }) async {
    try {
      final service = dio();
      final res = await service.get(
          '/api/v1/users/me/challenges/manage/$roomId/certifications?date_ym=$dateYM');

      Map<String, dynamic> result = res.data['result'];
      Map<String, List<FeedItem>> feedListByDateMap = {};

      for (final dateString in result.keys) {
        List<FeedItem> feedList = (result[dateString] as List<dynamic>)
            .map((e) => FeedItem.fromJson(e))
            .toList();
        feedListByDateMap[dateString] = feedList;
      }

      return feedListByDateMap;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static approveOrRejectFeed({
    required int roomId,
    required int feedId,
    required bool confirmValue,
  }) async {
    try {
      final service = dio();

      await service.patch(
          '/api/v1/users/me/challenges/manage/$roomId/certifications/$feedId?confirm_yn=${confirmValue ? 'Y' : 'N'}');

      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }
}
