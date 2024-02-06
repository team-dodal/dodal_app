import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';

List<Tag> parseTag(List<dynamic> tagList) =>
    tagList.map((e) => Tag(name: e['name'], value: e['value'])).toList();

List<MyCategory> parseCategory(List<dynamic> categoryList) => categoryList
    .map((e) => MyCategory(
          name: e['name'],
          subName: e['sub_name'],
          value: e['value'],
          emoji: e['emoji'],
          hashTags: e['hash_tags'],
        ))
    .toList();

class User extends Equatable {
  final int id;
  final String email;
  final String nickname;
  final String content;
  final String socialType;
  final String? profileUrl;
  final DateTime? registerAt;
  final List<MyCategory> categoryList;
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

  factory User.formJson(Map<String, dynamic> data) {
    return User(
      id: data['user_id'],
      email: data['email'],
      nickname: data['nickname'],
      content: data['content'],
      profileUrl: data['profile_url'],
      registerAt: DateTime.parse(data['register_at']),
      socialType: data['social_type'],
      categoryList: parseCategory(data['category_list']),
      tagList: parseTag(data['tag_list']),
    );
  }

  @override
  List<Object> get props => [
        id,
        email,
        nickname,
        content,
        socialType,
        profileUrl.toString(),
        registerAt.toString(),
        categoryList,
        tagList,
      ];
}
