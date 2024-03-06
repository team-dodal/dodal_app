import 'package:dodal_app/enum/certification_code_enum.dart';
import 'package:dodal_app/enum/day_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_member_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeMember extends Equatable {
  @JsonKey(name: 'challenge_room_id')
  final int challengeRoomId;
  @JsonKey(name: 'user_id')
  final int userId;
  final String nickname;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;
  @JsonKey(name: 'cert_success_cnt', defaultValue: 0)
  final int certSuccessCnt;
  @JsonKey(name: 'cert_fail_cnt', defaultValue: 0)
  final int certFailCnt;
  @JsonKey(
      name: 'user_week_cert_info_list', fromJson: createCertInfoListByJsonList)
  final List<ChallengeMemberCert> userWeekCertInfoList;

  const ChallengeMember({
    required this.challengeRoomId,
    required this.userId,
    required this.nickname,
    required this.profileUrl,
    required this.certSuccessCnt,
    required this.certFailCnt,
    required this.userWeekCertInfoList,
  });

  factory ChallengeMember.fromJson(Map<String, dynamic> json) =>
      _$ChallengeMemberFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeMemberToJson(this);

  static List<ChallengeMemberCert> createCertInfoListByJsonList(List? list) =>
      (list ?? [])
          .map((weekItem) => ChallengeMemberCert.fromJson(weekItem))
          .toList();

  @override
  List<Object?> get props => [
        challengeRoomId,
        userId,
        nickname,
        profileUrl,
        certSuccessCnt,
        certFailCnt,
        userWeekCertInfoList
      ];
}

@JsonSerializable()
class ChallengeMemberCert extends Equatable {
  @JsonKey(name: 'feed_id')
  final int feedId;
  @JsonKey(name: 'cert_image_url')
  final String? certImageUrl;
  @JsonKey(name: 'cert_code', fromJson: parseCertCode)
  final CertCode certCode;
  @JsonKey(name: 'day_code', fromJson: parseDayCode)
  final DayEnum dayCode;

  const ChallengeMemberCert({
    required this.feedId,
    required this.certImageUrl,
    required this.certCode,
    required this.dayCode,
  });

  factory ChallengeMemberCert.fromJson(Map<String, dynamic> json) =>
      _$ChallengeMemberCertFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeMemberCertToJson(this);

  static parseCertCode(code) => CertCode.values[(int.parse(code))];
  static parseDayCode(code) => DayEnum.values[(int.parse(code))];

  @override
  List<Object?> get props => [feedId, certImageUrl, certCode, dayCode];
}
