import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email, nickname, content, socialType;
  final String? profileUrl;
  final DateTime registerAt;
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

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        email,
        nickname,
        content,
        profileUrl.toString(),
        registerAt,
        socialType,
        tagList.toString(),
      ];
}
