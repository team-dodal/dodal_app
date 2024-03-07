import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Category extends Equatable {
  final String name;
  @JsonKey(name: 'sub_name')
  final String subName;
  final String emoji;
  final String? value;
  @JsonKey(fromJson: Tag.createTagListByJsonList, defaultValue: [])
  final List<Tag>? tags;

  const Category({
    required this.name,
    required this.subName,
    required this.value,
    required this.emoji,
    this.tags,
  });

  String get iconPath {
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

  List<String> get hashTags {
    switch (value) {
      case '001':
        return ['#몸 짱짱맨 되기', '#하나만 더'];
      case '002':
        return ['#불타는 의지', '#꼭 하고 만다'];
      case '003':
        return ['#인생의 재미', '#취미 찾기'];
      case '004':
        return ['#작은 것부터 차근차근'];
      case '005':
        return ['#뭐든지', '#도전은 늘 아름다워요'];
      default:
        return [];
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    String? name,
    String? subName,
    String? emoji,
    String? value,
    List<Tag>? tags,
  }) {
    return Category(
      name: name ?? this.name,
      subName: subName ?? this.subName,
      value: value ?? this.value,
      emoji: emoji ?? this.emoji,
      tags: tags ?? this.tags,
    );
  }

  static List<Category> createCategoryListByJsonList(List list) =>
      list.map((category) => Category.fromJson(category)).toList();

  @override
  List<Object?> get props => [name, subName, value, emoji, tags];
}
