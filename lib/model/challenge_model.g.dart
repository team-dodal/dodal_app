// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      id: json['challenge_room_id'] as int,
      adminId: json['host_id'] as int,
      adminNickname: json['host_nickname'] as String,
      adminProfile: json['host_profile_url'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      certCnt: json['cert_cnt'] as int,
      thumbnailImg: json['thumbnail_img_url'] as String?,
      recruitCnt: json['recruit_cnt'] as int,
      userCnt: json['user_cnt'] as int,
      bookmarkCnt: json['bookmark_cnt'] as int,
      isBookmarked: json['bookmark_yn'] == null
          ? 0
          : Challenge.isTrue(json['bookmark_yn']),
      isJoined: Challenge.isTrue(json['join_yn']),
      registeredAt: DateTime.parse(json['registered_at'] as String),
      categoryName: json['category_name'] as String,
      categoryValue: json['category_value'] as String,
      tagName: json['tag_name'],
      tagValue: json['tag_value'],
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'challenge_room_id': instance.id,
      'host_id': instance.adminId,
      'host_nickname': instance.adminNickname,
      'host_profile_url': instance.adminProfile,
      'title': instance.title,
      'content': instance.content,
      'cert_cnt': instance.certCnt,
      'thumbnail_img_url': instance.thumbnailImg,
      'recruit_cnt': instance.recruitCnt,
      'user_cnt': instance.userCnt,
      'bookmark_cnt': instance.bookmarkCnt,
      'bookmark_yn': instance.isBookmarked,
      'join_yn': instance.isJoined,
      'registered_at': instance.registeredAt.toIso8601String(),
      'category_name': instance.categoryName,
      'category_value': instance.categoryValue,
      'tag_name': instance.tagName,
      'tag_value': instance.tagValue,
    };
