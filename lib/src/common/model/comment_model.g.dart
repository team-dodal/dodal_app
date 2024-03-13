// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentResponseFromJson(Map<String, dynamic> json) => Comment(
      commentId: json['comment_id'] as int,
      feedId: json['feed_id'] as int,
      userId: json['user_id'] as int,
      nickname: json['nickname'] as String,
      profileUrl: json['profile_url'] as String?,
      parentId: json['parent_id'] as int?,
      content: json['content'] as String,
      registerCode: json['register_code'] as String,
      registeredAt: json['registered_at'] as String,
      children: Comment.createCommentListByJsonList(json['children'] as List),
    );

Map<String, dynamic> _$CommentResponseToJson(Comment instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'feed_id': instance.feedId,
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'profile_url': instance.profileUrl,
      'parent_id': instance.parentId,
      'content': instance.content,
      'register_code': instance.registerCode,
      'registered_at': instance.registeredAt,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };
