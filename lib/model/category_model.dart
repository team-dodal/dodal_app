import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String subName;
  final String emoji;
  final String? value;
  List<Tag> tags;
  late String iconPath;

  Category({
    required this.name,
    required this.subName,
    required this.value,
    required this.emoji,
    required this.tags,
  }) {
    if (value != null) {
      iconPath = _getIconPath(value);
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    final List<Tag> tagList = (json['tags'] as List).map((tag) {
      return Tag(name: tag['name'], value: tag['value']);
    }).toList();

    return Category(
      name: json['name'],
      subName: json['sub_name'],
      value: json['value'],
      emoji: json['emoji'],
      tags: tagList,
    );
  }

  String _getIconPath(value) {
    switch (value) {
      case '001':
        return 'assets/icons/category/health_category_icon.svg';
      case '002':
        return 'assets/icons/category/book_category_icon.svg';
      case '003':
        return 'assets/icons/category/pen_category_icon.svg';
      case '004':
        return 'assets/icons/category/clock_category_icon.svg';
      case '005':
        return 'assets/icons/category/light_category_icon.svg';
      default:
        return '';
    }
  }

  @override
  List<Object?> get props => [name, subName, emoji, value, tags, iconPath];
}

class MyCategory {
  final String name, subName, value, emoji;
  final List<dynamic> hashTags;

  MyCategory({
    required this.name,
    required this.subName,
    required this.value,
    required this.emoji,
    required this.hashTags,
  });
}
