import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'user_id')
  final int id;
  final String email;
  final String nickname;
  final String content;
  @JsonKey(name: 'social_type')
  final String socialType;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;
  @JsonKey(name: 'register_at', fromJson: DateTime.parse)
  final DateTime registerAt;
  @JsonKey(
      name: 'category_list', fromJson: Category.createCategoryListByJsonList)
  final List<Category> categoryList;
  @JsonKey(name: 'tag_list', fromJson: Tag.createTagListByJsonList)
  final List<Tag> tagList;

  const User({
    required this.id,
    required this.email,
    required this.nickname,
    required this.content,
    required this.profileUrl,
    required this.registerAt,
    required this.socialType,
    required this.categoryList,
    required this.tagList,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        nickname,
        content,
        profileUrl,
        registerAt,
        socialType,
        categoryList,
        tagList,
      ];
}
