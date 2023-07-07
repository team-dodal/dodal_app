import 'package:dodal_app/model/tag_model.dart';

class Category {
  Category({
    required this.name,
    required this.value,
    required this.tags,
  });

  final String name;
  final String value;
  final List<Tag> tags;
}
