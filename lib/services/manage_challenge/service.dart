import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';

class ManageChallengeService {
  static Future<List<MyChallengesResponse>?> myChallenges() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/users/me/challenges/user');
      List<dynamic> result = res.data['result'];
      List<MyChallengesResponse> list =
          result.map((item) => MyChallengesResponse.fromJson(item)).toList();
      return list;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }
}
