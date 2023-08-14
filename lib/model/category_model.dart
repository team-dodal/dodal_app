import 'package:dodal_app/model/tag_model.dart';

class Category {
  Category({
    required this.name,
    required this.subName,
    required this.value,
    required this.emoji,
    required this.tags,
  }) {
    iconPath = getIconPath(value);
  }

  final String name, subName, value, emoji;
  final List<Tag> tags;
  late String iconPath;

  getIconPath(value) {
    switch (value) {
      case '001':
        return 'assets/icons/health_category_icon.svg';
      case '002':
        return 'assets/icons/book_category_icon.svg';
      case '003':
        return 'assets/icons/clock_category_icon.svg';
      case '004':
        return 'assets/icons/pen_category_icon.svg';
      case '005':
        return 'assets/icons/light_category_icon.svg';
    }
  }
}

List<Category> parseCategoriesByJson(Map<String, dynamic> data) {
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
