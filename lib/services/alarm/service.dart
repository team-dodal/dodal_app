import 'package:dio/dio.dart';
import 'package:dodal_app/services/alarm/response.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import '../common/main.dart';

class AlarmService {
  static final service = dio('/api/v1/alarm');

  static Future<List<AlarmResponse>?> getAllAlarmList({
    required int userId,
  }) async {
    try {
      final res = await service.get('/$userId');

      List<dynamic> responseData = res.data['result'];
      return responseData.map((e) => AlarmResponse.fromJson(e)).toList();
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static deleteAllAlarmList({required int userId}) async {
    try {
      await service.delete('/$userId');
      return true;
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }
}
