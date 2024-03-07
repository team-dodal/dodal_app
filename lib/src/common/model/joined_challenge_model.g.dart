// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joined_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinedChallenge _$JoinedChallengeFromJson(Map<String, dynamic> json) =>
    JoinedChallenge(
      id: json['challenge_room_id'] as int,
      adminId: json['user_id'] as int,
      adminNickname: json['nickname'] as String,
      adminProfileUrl: json['profile_url'] as String?,
      title: json['title'] as String,
      certCnt: json['cert_cnt'] as int,
      thumbnailImg: json['thumbnail_img_url'] as String?,
      recruitCnt: json['recruit_cnt'] as int,
      userCnt: json['user_cnt'] as int,
      bookmarkCnt: json['bookmark_cnt'] as int,
      bookmarkYn: JoinedChallenge.isTrue(json['bookmark_yn'] as String?),
      registeredAt: DateTime.parse(json['registered_at'] as String),
      categoryName: json['category_name'] as String,
      categoryValue: json['category_value'] as String,
      tagName: json['tag_name'] as String,
      tagValue: json['tag_value'] as String,
      weekUserCertCnt: json['week_user_cert_cnt'] as int,
      certCode: JoinedChallenge.parseCertCode(json['cert_code'] as String?),
    );

Map<String, dynamic> _$JoinedChallengeToJson(JoinedChallenge instance) =>
    <String, dynamic>{
      'challenge_room_id': instance.id,
      'user_id': instance.adminId,
      'nickname': instance.adminNickname,
      'profile_url': instance.adminProfileUrl,
      'title': instance.title,
      'cert_cnt': instance.certCnt,
      'thumbnail_img_url': instance.thumbnailImg,
      'recruit_cnt': instance.recruitCnt,
      'user_cnt': instance.userCnt,
      'bookmark_cnt': instance.bookmarkCnt,
      'bookmark_yn': instance.bookmarkYn,
      'registered_at': instance.registeredAt.toIso8601String(),
      'category_name': instance.categoryName,
      'category_value': instance.categoryValue,
      'tag_name': instance.tagName,
      'tag_value': instance.tagValue,
      'week_user_cert_cnt': instance.weekUserCertCnt,
      'cert_code': _$CertCodeEnumMap[instance.certCode],
    };

const _$CertCodeEnumMap = {
  CertCode.fail: 'fail',
  CertCode.pending: 'pending',
  CertCode.success: 'success',
};
