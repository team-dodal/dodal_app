import 'package:dio/dio.dart';
import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';

import '../common/main.dart';

class CategoryService {
  static Future<List<Category>?> getAllCategories() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/categories/tags');

      final responseData = res.data['result'];
      final List<Category> categories = parseCategoriesByJson(responseData);

      return categories;
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }
}
