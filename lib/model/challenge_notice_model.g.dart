// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeNotice _$ChallengeNoticeFromJson(Map<String, dynamic> json) =>
    ChallengeNotice(
      id: json['noti_id'] as int,
      roomId: json['room_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$ChallengeNoticeToJson(ChallengeNotice instance) =>
    <String, dynamic>{
      'noti_id': instance.id,
      'room_id': instance.roomId,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date,
    };
