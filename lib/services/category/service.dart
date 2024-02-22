import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/services/common/main.dart';

class CategoryService {
  static Future<List<Category>> getAllCategories() async {
    final service = dio();
    final res = await service.get('/api/v1/categories/tags');

    final responseData = res.data['result'];
    List<Category> categories = responseData['categories']
        .map<Category>((value) => Category.fromJson(value))
        .toList();

    return categories;
  }
}
