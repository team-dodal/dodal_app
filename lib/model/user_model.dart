import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email, nickname, content, socialType;
  final String? profileUrl;
  final DateTime? registerAt;
  final List<Tag> tagList;

  const User({
    required this.id,
    required this.email,
    required this.nickname,
    required this.content,
    required this.profileUrl,
    required this.registerAt,
    required this.socialType,
    required this.tagList,
  });

  User.formJson(Map<String, dynamic> data)
      : id = data['user_id'],
        email = data['email'],
        nickname = data['nickname'],
        content = data['content'],
        profileUrl = data['profile_url'],
        registerAt = data['register_at'] != null
            ? DateTime.parse(data['register_at'])
            : null,
        socialType = data['social_type'],
        tagList = (data['tag_list'] as List<dynamic>?)
                ?.map((e) => Tag(name: e['name'], value: e['value']))
                .toList() ??
            [];

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        email,
        nickname,
        content,
        profileUrl.toString(),
        registerAt.toString(),
        socialType,
        tagList.toString(),
      ];
}
