import 'package:dodal_app/model/alarm_content_model.dart';
import 'package:dodal_app/services/common/main.dart';

class AlarmService {
  static final service = dio('/api/v1/alarm');

  static Future<List<AlarmContent>> getAllAlarmList({
    required int userId,
  }) async {
    final res = await service.get('/$userId');
    List<dynamic> responseData = res.data['result'];
    return responseData.map((e) => AlarmContent.fromJson(e)).toList();
  }

  static Future<void> deleteAllAlarmList({required int userId}) async {
    await service.delete('/$userId');
  }
}
