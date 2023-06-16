import 'package:dodal_app/services/common/main.dart';

class ApiTest {
  static test() async {
    try {
      final service = await dio();
      final res = await service.request('/');
      return res;
    } catch (err) {
      throw Exception(err);
    }
  }
}
