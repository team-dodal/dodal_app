import 'package:dodal_app/services/common/main.dart';

class CategoryService {
  static getAllTags() async {
    try {
      final service = await dio();
      final res = await service.get('/api/v1/categories/tags');
      return res.data['result'];
    } catch (err) {
      throw Exception(err);
    }
  }
}
