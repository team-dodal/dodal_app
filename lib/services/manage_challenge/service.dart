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
}
