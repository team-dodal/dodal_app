import 'package:dio/dio.dart';
import 'package:dodal_app/src/common/model/challenge_member_model.dart';
import 'package:dodal_app/src/common/model/host_challenge_model.dart';
import 'package:dodal_app/src/common/model/joined_challenge_model.dart';
import 'package:dodal_app/src/common/model/members_feed_model.dart';
import 'package:dodal_app/src/common/repositories/common/error_dialog.dart';
import 'package:dodal_app/src/common/repositories/common/main.dart';

class ManageChallengeRepository {
  static final service = dio();

  static Future<List<JoinedChallenge>> joinedChallenges() async {
    final res = await service.get('/api/v1/users/me/challenges/user');
    List<dynamic> result = res.data['result'];
    List<JoinedChallenge> list =
        result.map((item) => JoinedChallenge.fromJson(item)).toList();
    return list;
  }

  static Future<List<HostChallenge>?> hostChallenges() async {
    final res = await service.get('/api/v1/users/me/challenges/host');
    List<dynamic> result = res.data['result'];
    List<HostChallenge> list =
        result.map((item) => HostChallenge.fromJson(item)).toList();
    return list;
  }

  static manageUsers({required int roomId}) async {
    final res =
        await service.get('/api/v1/users/me/challenges/manage/$roomId/users');
    List<dynamic> result = res.data['result'];
    List<ChallengeMember> list =
        result.map((item) => ChallengeMember.fromJson(item)).toList();
    return list;
  }

  static Future<Map<String, List<MembersFeed>>> getCertificationList({
    required int roomId,
    required String dateYM,
  }) async {
    final res = await service.get(
        '/api/v1/users/me/challenges/manage/$roomId/certifications?date_ym=$dateYM');

    Map<String, dynamic> result = res.data['result'];
    Map<String, List<MembersFeed>> feedListByDateMap = {};

    for (final dateString in result.keys) {
      List<MembersFeed> feedList = (result[dateString] as List<dynamic>)
          .map((e) => MembersFeed.fromJson(e))
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
