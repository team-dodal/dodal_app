import 'package:dodal_app/model/tag_model.dart';

class Category {
  Category({
    required this.name,
    required this.subName,
    required this.value,
    required this.emoji,
    required this.tags,
  });

  final String name, subName, value, emoji;
  final List<Tag> tags;
}
