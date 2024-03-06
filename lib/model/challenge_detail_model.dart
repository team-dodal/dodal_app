import 'package:dodal_app/enum/certification_code_enum.dart';
import 'package:dodal_app/enum/day_enum.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeDetail extends Equatable {
  @JsonKey(name: 'room_id')
  final int id;
  @JsonKey(name: 'thumbnail_img_url')
  final String? thumbnailImgUrl;
  @JsonKey(name: 'tag_name')
  final String tagName;
  @JsonKey(name: 'tag_value')
  final String tagValue;
  @JsonKey(name: 'cert_cnt')
  final int certCnt;
  final String title;
  @JsonKey(name: 'host_id')
  final int hostId;
  @JsonKey(name: 'host_nickname')
  final String hostNickname;
  @JsonKey(name: 'host_profile_url')
  final String? hostProfileUrl;
  @JsonKey(name: 'user_cnt')
  final int userCnt;
  @JsonKey(name: 'recruit_cnt')
  final int recruitCnt;
  final String content;
  @JsonKey(name: 'feed_url_list')
  final List<dynamic> feedUrlList;
  @JsonKey(name: 'cert_content')
  final String certContent;
  @JsonKey(name: 'cert_correct_img_url')
  final String? certCorrectImgUrl;
  @JsonKey(name: 'cert_wrong_img_url')
  final String? certWrongImgUrl;
  @JsonKey(name: 'bookmark_cnt')
  final int bookmarkCnt;
  @JsonKey(name: 'bookmark_yn', fromJson: isTrue)
  final bool isBookmarked;
  @JsonKey(name: 'join_yn', fromJson: isTrue)
  final bool isJoin;
  @JsonKey(name: 'today_cert_code', fromJson: parseCertCode)
  final CertCode? todayCertCode;
  @JsonKey(name: 'accuse_cnt')
  final int accuseCnt;
  @JsonKey(name: 'notice_title')
  final String? noticeTitle;
  @JsonKey(name: 'notice_content')
  final String? noticeContent;
  @JsonKey(name: 'registered_at', fromJson: DateTime.parse)
  final DateTime registeredAt;
  @JsonKey(
      name: 'user_cert_per_week_list', fromJson: createUserCertListByJsonList)
  final List<UserCertPerWeek> userCertPerWeekList;
  @JsonKey(name: 'continue_cert_cnt', fromJson: int.parse)
  final int? continueCertCnt;

  const ChallengeDetail({
    required this.id,
    required this.thumbnailImgUrl,
    required this.tagName,
    required this.tagValue,
    required this.certCnt,
    required this.title,
    required this.hostId,
    required this.hostNickname,
    required this.hostProfileUrl,
    required this.userCnt,
    required this.recruitCnt,
    required this.content,
    required this.feedUrlList,
    required this.certContent,
    required this.certCorrectImgUrl,
    required this.certWrongImgUrl,
    required this.bookmarkCnt,
    required this.isBookmarked,
    required this.isJoin,
    required this.todayCertCode,
    required this.accuseCnt,
    required this.noticeTitle,
    required this.noticeContent,
    required this.registeredAt,
    required this.userCertPerWeekList,
    required this.continueCertCnt,
  });
  get tag => Tag(name: tagName, value: tagValue);

  factory ChallengeDetail.fromJson(Map<String, dynamic> data) =>
      _$ChallengeDetailFromJson(data);

  Map<String, dynamic> toJson() => _$ChallengeDetailToJson(this);

  static isTrue(String? value) => value == 'Y';
  static parseCertCode(String? value) =>
      value != null ? CertCode.values[int.parse(value)] : null;
  static createUserCertListByJsonList(List? list) =>
      (list ?? []).map((e) => UserCertPerWeek.fromJson(e)).toList();

  @override
  List<Object?> get props => [
        id,
        thumbnailImgUrl,
        tagName,
        tagValue,
        certCnt,
        title,
        hostId,
        hostNickname,
        hostProfileUrl,
        userCnt,
        recruitCnt,
        content,
        feedUrlList,
        certContent,
        certCorrectImgUrl,
        certWrongImgUrl,
        bookmarkCnt,
        isBookmarked,
        isJoin,
        todayCertCode,
        accuseCnt,
        noticeTitle,
        noticeContent,
        registeredAt,
        userCertPerWeekList,
        continueCertCnt,
      ];
}

@JsonSerializable()
class UserCertPerWeek extends Equatable {
  @JsonKey(name: 'day_code', fromJson: parseDayCode)
  final DayEnum dayCode;
  @JsonKey(name: 'cert_img_url')
  final String? certImageUrl;

  const UserCertPerWeek({required this.dayCode, required this.certImageUrl});

  factory UserCertPerWeek.fromJson(Map<String, dynamic> data) =>
      _$UserCertPerWeekFromJson(data);

  Map<String, dynamic> toJson() => _$UserCertPerWeekToJson(this);

  static parseDayCode(int dayCode) => DayEnum.values[dayCode];

  @override
  List<Object?> get props => [dayCode, certImageUrl];
}
