// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_calendar_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCalendarData _$UserCalendarDataFromJson(Map<String, dynamic> json) =>
    UserCalendarData(
      feedId: json['feed_id'] as int,
      certImageUrl: json['cert_image_url'] as String,
      day: json['day'] as String,
    );

Map<String, dynamic> _$UserCalendarDataToJson(UserCalendarData instance) =>
    <String, dynamic>{
      'feed_id': instance.feedId,
      'cert_image_url': instance.certImageUrl,
      'day': instance.day,
    };
