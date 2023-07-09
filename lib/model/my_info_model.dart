import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email, nickname, profileUrl, socialType;
  final DateTime registerAt;
  final List<Tag> tagList;

  User.fromJson(Map<String, dynamic> data)
      : id = data['user_id'],
        email = data['email'],
        nickname = data['nickname'],
        profileUrl = data['profile_url'] ?? '',
        registerAt = DateTime.parse(data['register_at']),
        socialType = data['social_type'],
        tagList = (data['tag_list'] as List<dynamic>)
            .map((e) => Tag(name: e['name'], value: e['value']))
            .toList();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        email,
        nickname,
        profileUrl,
        registerAt,
        socialType,
        tagList.toString(),
      ];
}
