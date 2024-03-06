// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmContent _$AlarmContentFromJson(Map<String, dynamic> json) => AlarmContent(
      userId: json['user_id'] as int,
      roomId: json['room_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      registeredAt: DateTime.parse(json['registered_at'] as String),
      registerCode: json['register_code'] as String,
    );

Map<String, dynamic> _$AlarmContentToJson(AlarmContent instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'room_id': instance.roomId,
      'title': instance.title,
      'content': instance.content,
      'registered_at': instance.registeredAt.toIso8601String(),
      'register_code': instance.registerCode,
    };
