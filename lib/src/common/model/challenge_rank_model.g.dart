// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_rank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeRank _$ChallengeRankFromJson(Map<String, dynamic> json) =>
    ChallengeRank(
      userId: json['user_id'] as int,
      nickname: json['nickname'] as String,
      certCnt: json['cert_cnt'] as int,
      profileUrl: json['profile_url'] as String?,
    );

Map<String, dynamic> _$ChallengeRankToJson(ChallengeRank instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'cert_cnt': instance.certCnt,
      'profile_url': instance.profileUrl,
    };
