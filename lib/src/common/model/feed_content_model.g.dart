// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedContent _$FeedContentFromJson(Map<String, dynamic> json) => FeedContent(
      roomId: json['room_id'] as int,
      feedId: json['feed_id'] as int,
      certCnt: json['cert_cnt'] as int,
      title: json['title'] as String,
      categoryName: json['category_name'] as String,
      userId: json['user_id'] as int,
      profileUrl: json['profile_url'] as String?,
      nickname: json['nickname'] as String,
      continueCertCnt: json['continue_cert_cnt'] as int,
      certImgUrl: json['cert_img_url'] as String,
      certContent: json['cert_content'] as String,
      accuseCnt: json['accuse_cnt'] as int,
      joinYn: json['join_yn'] == null
          ? false
          : FeedContent.isTrue(json['join_yn'] as String),
      registeredAt: DateTime.parse(json['registered_at'] as String),
      registerCode: json['register_code'] as String,
      commentCnt: json['comment_cnt'] as int,
      likeCnt: json['like_cnt'] as int,
      likeYn: FeedContent.isTrue(json['like_yn'] as String),
    );

Map<String, dynamic> _$FeedContentToJson(FeedContent instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'feed_id': instance.feedId,
      'cert_cnt': instance.certCnt,
      'title': instance.title,
      'category_name': instance.categoryName,
      'user_id': instance.userId,
      'profile_url': instance.profileUrl,
      'nickname': instance.nickname,
      'continue_cert_cnt': instance.continueCertCnt,
      'cert_img_url': instance.certImgUrl,
      'cert_content': instance.certContent,
      'like_cnt': instance.likeCnt,
      'accuse_cnt': instance.accuseCnt,
      'like_yn': instance.likeYn,
      'join_yn': instance.joinYn,
      'registered_at': instance.registeredAt.toIso8601String(),
      'register_code': instance.registerCode,
      'comment_cnt': instance.commentCnt,
    };
