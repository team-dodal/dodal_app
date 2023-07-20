import '../model/category_model.dart';
import '../model/tag_model.dart';
import 'common/main.dart';

List<Category> parseCategories(Map<String, dynamic> data) {
  final List<dynamic> categoryList = data['categories'];
  final List<Category> categories = categoryList.map((categoryData) {
    final List<dynamic> tagList = categoryData['tags'];
    final List<Tag> tags = tagList.map((tagData) {
      return Tag(
        name: tagData['name'],
        value: tagData['value'],
      );
    }).toList();

    return Category(
      name: categoryData['name'],
      subName: categoryData['sub_name'],
      value: categoryData['value'],
      emoji: categoryData['emoji'],
      tags: tags,
    );
  }).toList();

  return categories;
}

class CategoryService {
  static Future<List<Category>> getAllCategories() async {
    try {
      final service = await dio();
      final res = await service.get('/api/v1/categories/tags');

      final responseData = res.data['result'];
      final List<Category> categories = parseCategories(responseData);

      return categories;
    } catch (err) {
      throw Exception(err);
    }
  }
}
