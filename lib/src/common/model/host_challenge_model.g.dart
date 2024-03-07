// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostChallenge _$HostChallengeFromJson(Map<String, dynamic> json) =>
    HostChallenge(
      challengeRoomId: json['challenge_room_id'] as int,
      userId: json['user_id'] as int,
      nickname: json['nickname'] as String,
      profileUrl: json['profile_url'] as String?,
      title: json['title'] as String,
      certCnt: json['cert_cnt'] as int,
      thumbnailImgUrl: json['thumbnail_img_url'] as String?,
      recruitCnt: json['recruit_cnt'] as int,
      userCnt: json['user_cnt'] as int,
      bookmarkCnt: json['bookmark_cnt'] as int,
      bookmarkYn: HostChallenge.isTrue(json['bookmark_yn'] as String?),
      registeredAt: DateTime.parse(json['registered_at'] as String),
      categoryName: json['category_name'] as String,
      categoryValue: json['category_value'] as String,
      tagName: json['tag_name'] as String,
      tagValue: json['tag_value'] as String,
      certRequestCnt: json['cert_request_cnt'] as int,
    );

Map<String, dynamic> _$HostChallengeToJson(HostChallenge instance) =>
    <String, dynamic>{
      'challenge_room_id': instance.challengeRoomId,
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'profile_url': instance.profileUrl,
      'title': instance.title,
      'cert_cnt': instance.certCnt,
      'thumbnail_img_url': instance.thumbnailImgUrl,
      'recruit_cnt': instance.recruitCnt,
      'user_cnt': instance.userCnt,
      'bookmark_cnt': instance.bookmarkCnt,
      'bookmark_yn': instance.bookmarkYn,
      'registered_at': instance.registeredAt.toIso8601String(),
      'category_name': instance.categoryName,
      'category_value': instance.categoryValue,
      'tag_name': instance.tagName,
      'tag_value': instance.tagValue,
      'cert_request_cnt': instance.certRequestCnt,
    };
