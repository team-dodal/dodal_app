// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeDetail _$ChallengeDetailFromJson(Map<String, dynamic> json) =>
    ChallengeDetail(
      id: json['room_id'] as int,
      thumbnailImgUrl: json['thumbnail_img_url'] as String?,
      tagName: json['tag_name'] as String,
      tagValue: json['tag_value'] as String,
      certCnt: json['cert_cnt'] as int,
      title: json['title'] as String,
      hostId: json['host_id'] as int,
      hostNickname: json['host_nickname'] as String,
      hostProfileUrl: json['host_profile_url'] as String?,
      userCnt: json['user_cnt'] as int,
      recruitCnt: json['recruit_cnt'] as int,
      content: json['content'] as String,
      feedUrlList: json['feed_url_list'] as List<dynamic>,
      certContent: json['cert_content'] as String,
      certCorrectImgUrl: json['cert_correct_img_url'] as String?,
      certWrongImgUrl: json['cert_wrong_img_url'] as String?,
      bookmarkCnt: json['bookmark_cnt'] as int,
      isBookmarked: ChallengeDetail.isTrue(json['bookmark_yn'] as String?),
      isJoin: ChallengeDetail.isTrue(json['join_yn'] as String?),
      todayCertCode:
          ChallengeDetail.parseCertCode(json['today_cert_code'] as String?),
      accuseCnt: json['accuse_cnt'] as int,
      noticeTitle: json['notice_title'] as String?,
      noticeContent: json['notice_content'] as String?,
      registeredAt: DateTime.parse(json['registered_at'] as String),
      userCertPerWeekList: ChallengeDetail.createUserCertListByJsonList(
          json['user_cert_per_week_list'] as List?),
      continueCertCnt: int.parse(json['continue_cert_cnt'] as String),
    );

Map<String, dynamic> _$ChallengeDetailToJson(ChallengeDetail instance) =>
    <String, dynamic>{
      'room_id': instance.id,
      'thumbnail_img_url': instance.thumbnailImgUrl,
      'tag_name': instance.tagName,
      'tag_value': instance.tagValue,
      'cert_cnt': instance.certCnt,
      'title': instance.title,
      'host_id': instance.hostId,
      'host_nickname': instance.hostNickname,
      'host_profile_url': instance.hostProfileUrl,
      'user_cnt': instance.userCnt,
      'recruit_cnt': instance.recruitCnt,
      'content': instance.content,
      'feed_url_list': instance.feedUrlList,
      'cert_content': instance.certContent,
      'cert_correct_img_url': instance.certCorrectImgUrl,
      'cert_wrong_img_url': instance.certWrongImgUrl,
      'bookmark_cnt': instance.bookmarkCnt,
      'bookmark_yn': instance.isBookmarked,
      'join_yn': instance.isJoin,
      'today_cert_code': _$CertCodeEnumMap[instance.todayCertCode],
      'accuse_cnt': instance.accuseCnt,
      'notice_title': instance.noticeTitle,
      'notice_content': instance.noticeContent,
      'registered_at': instance.registeredAt.toIso8601String(),
      'user_cert_per_week_list':
          instance.userCertPerWeekList.map((e) => e.toJson()).toList(),
      'continue_cert_cnt': instance.continueCertCnt,
    };

const _$CertCodeEnumMap = {
  CertCode.fail: 'fail',
  CertCode.pending: 'pending',
  CertCode.success: 'success',
};

UserCertPerWeek _$UserCertPerWeekFromJson(Map<String, dynamic> json) =>
    UserCertPerWeek(
      dayCode: UserCertPerWeek.parseDayCode(json['day_code'] as int),
      certImageUrl: json['cert_img_url'] as String?,
    );

Map<String, dynamic> _$UserCertPerWeekToJson(UserCertPerWeek instance) =>
    <String, dynamic>{
      'day_code': _$DayEnumEnumMap[instance.dayCode]!,
      'cert_img_url': instance.certImageUrl,
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
