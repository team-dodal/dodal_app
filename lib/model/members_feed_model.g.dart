// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembersFeed _$MembersFeedFromJson(Map<String, dynamic> json) => MembersFeed(
      challengeRoomId: json['challenge_room_id'] as int,
      challengeFeedId: json['challenge_feed_id'] as int,
      requestUserId: json['request_user_id'] as int,
      requestUserNickname: json['request_user_nickname'] as String,
      certImageUrl: json['cert_image_url'] as String?,
      certContent: json['cert_content'] as String,
      certCode: json['cert_code'] as String,
      registeredAt: json['registered_at'] as String,
      registeredDate: json['registered_date'] as String,
    );

Map<String, dynamic> _$MembersFeedToJson(MembersFeed instance) =>
    <String, dynamic>{
      'challenge_room_id': instance.challengeRoomId,
      'challenge_feed_id': instance.challengeFeedId,
      'request_user_id': instance.requestUserId,
      'request_user_nickname': instance.requestUserNickname,
      'cert_image_url': instance.certImageUrl,
      'cert_content': instance.certContent,
      'cert_code': instance.certCode,
      'registered_at': instance.registeredAt,
      'registered_date': instance.registeredDate,
    };
