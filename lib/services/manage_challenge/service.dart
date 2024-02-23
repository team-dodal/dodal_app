import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';

class ManageChallengeService {
  static final service = dio();

  static Future<List<JoinedChallengesResponse>> joinedChallenges() async {
    final res = await service.get('/api/v1/users/me/challenges/user');
    List<dynamic> result = res.data['result'];
    List<JoinedChallengesResponse> list =
        result.map((item) => JoinedChallengesResponse.fromJson(item)).toList();
    return list;
  }

  static Future<List<HostChallengesResponse>?> hostChallenges() async {
    final res = await service.get('/api/v1/users/me/challenges/host');
    List<dynamic> result = res.data['result'];
    List<HostChallengesResponse> list =
        result.map((item) => HostChallengesResponse.fromJson(item)).toList();
    return list;
  }

  static manageUsers({required int roomId}) async {
    final res =
        await service.get('/api/v1/users/me/challenges/manage/$roomId/users');
    List<dynamic> result = res.data['result'];
    List<ChallengeUser> list =
        result.map((item) => ChallengeUser.fromJson(item)).toList();
    return list;
  }

  static Future<Map<String, List<FeedItem>>> getCertificationList({
    required int roomId,
    required String dateYM,
  }) async {
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
  }

  static approveOrRejectFeed({
    required int roomId,
    required int feedId,
    required bool confirmValue,
  }) async {
    await service.patch(
        '/api/v1/users/me/challenges/manage/$roomId/certifications/$feedId?confirm_yn=${confirmValue ? 'Y' : 'N'}');
  }

  static handOverAdmin({
    required int roomId,
    required int userId,
  }) async {
    try {
      await service.patch(
        '/api/v1/users/me/challenges/manage/$roomId/mandate',
        data: {"user_id": userId},
      );

      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static banishUser({
    required int roomId,
    required int userId,
  }) async {
    try {
      await service.delete(
        '/api/v1/users/me/challenges/manage/$roomId/users/$userId',
      );

      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }
}
