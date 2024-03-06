// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeMember _$ChallengeMemberFromJson(Map<String, dynamic> json) =>
    ChallengeMember(
      challengeRoomId: json['challenge_room_id'] as int,
      userId: json['user_id'] as int,
      nickname: json['nickname'] as String,
      profileUrl: json['profile_url'] as String?,
      certSuccessCnt: json['cert_success_cnt'] as int? ?? 0,
      certFailCnt: json['cert_fail_cnt'] as int? ?? 0,
      userWeekCertInfoList: ChallengeMember.createCertInfoListByJsonList(
          json['user_week_cert_info_list'] as List?),
    );

Map<String, dynamic> _$ChallengeMemberToJson(ChallengeMember instance) =>
    <String, dynamic>{
      'challenge_room_id': instance.challengeRoomId,
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'profile_url': instance.profileUrl,
      'cert_success_cnt': instance.certSuccessCnt,
      'cert_fail_cnt': instance.certFailCnt,
      'user_week_cert_info_list':
          instance.userWeekCertInfoList.map((e) => e.toJson()).toList(),
    };

ChallengeMemberCert _$ChallengeMemberCertFromJson(Map<String, dynamic> json) =>
    ChallengeMemberCert(
      feedId: json['feed_id'] as int,
      certImageUrl: json['cert_image_url'] as String?,
      certCode: ChallengeMemberCert.parseCertCode(json['cert_code']),
      dayCode: ChallengeMemberCert.parseDayCode(json['day_code']),
    );

Map<String, dynamic> _$ChallengeMemberCertToJson(
        ChallengeMemberCert instance) =>
    <String, dynamic>{
      'feed_id': instance.feedId,
      'cert_image_url': instance.certImageUrl,
      'cert_code': _$CertCodeEnumMap[instance.certCode]!,
      'day_code': _$DayEnumEnumMap[instance.dayCode]!,
    };

const _$CertCodeEnumMap = {
  CertCode.fail: 'fail',
  CertCode.pending: 'pending',
  CertCode.success: 'success',
};

const _$DayEnumEnumMap = {
  DayEnum.monday: 'monday',
  DayEnum.tuesday: 'tuesday',
  DayEnum.wednesday: 'wednesday',
  DayEnum.thursday: 'thursday',
  DayEnum.friday: 'friday',
  DayEnum.saturday: 'saturday',
  DayEnum.sunday: 'sunday',
};
