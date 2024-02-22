import 'package:dodal_app/services/alarm/response.dart';
import 'package:dodal_app/services/common/main.dart';

class AlarmService {
  static final service = dio('/api/v1/alarm');

  static Future<List<AlarmResponse>> getAllAlarmList({
    required int userId,
  }) async {
    final res = await service.get('/$userId');
    List<dynamic> responseData = res.data['result'];
    return responseData.map((e) => AlarmResponse.fromJson(e)).toList();
  }

  static Future<void> deleteAllAlarmList({required int userId}) async {
    await service.delete('/$userId');
  }
}
