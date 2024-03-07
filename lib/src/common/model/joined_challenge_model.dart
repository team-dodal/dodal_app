import 'package:dodal_app/src/common/enum/certification_code_enum.dart';
import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'joined_challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class JoinedChallenge extends Equatable {
  @JsonKey(name: 'challenge_room_id')
  final int id;
  @JsonKey(name: 'user_id')
  final int adminId;
  @JsonKey(name: 'nickname')
  final String adminNickname;
  @JsonKey(name: 'profile_url')
  final String? adminProfileUrl;
  final String title;
  @JsonKey(name: 'cert_cnt')
  final int certCnt;
  @JsonKey(name: 'thumbnail_img_url')
  final String? thumbnailImg;
  @JsonKey(name: 'recruit_cnt')
  final int recruitCnt;
  @JsonKey(name: 'user_cnt')
  final int userCnt;
  @JsonKey(name: 'bookmark_cnt')
  final int bookmarkCnt;
  @JsonKey(name: 'bookmark_yn', fromJson: isTrue)
  final bool bookmarkYn;
  @JsonKey(name: 'registered_at', fromJson: DateTime.parse)
  final DateTime registeredAt;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'category_value')
  final String categoryValue;
  @JsonKey(name: 'tag_name')
  final String tagName;
  @JsonKey(name: 'tag_value')
  final String tagValue;
  @JsonKey(name: 'week_user_cert_cnt')
  final int weekUserCertCnt;
  @JsonKey(name: 'cert_code', fromJson: parseCertCode)
  final CertCode? certCode;

  const JoinedChallenge({
    required this.id,
    required this.adminId,
    required this.adminNickname,
    required this.adminProfileUrl,
    required this.title,
    required this.certCnt,
    required this.thumbnailImg,
    required this.recruitCnt,
    required this.userCnt,
    required this.bookmarkCnt,
    required this.bookmarkYn,
    required this.registeredAt,
    required this.categoryName,
    required this.categoryValue,
    required this.tagName,
    required this.tagValue,
    required this.weekUserCertCnt,
    required this.certCode,
  });

  factory JoinedChallenge.fromJson(Map<String, dynamic> json) =>
      _$JoinedChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$JoinedChallengeToJson(this);

  get tag => Tag(name: tagName, value: tagValue);

  static isTrue(String? value) => value == 'Y';
  static parseCertCode(String? value) =>
      value != null ? CertCode.values[int.parse(value)] : null;

  @override
  List<Object?> get props => [
        id,
        adminId,
        adminNickname,
        adminProfileUrl,
        title,
        certCnt,
        thumbnailImg,
        recruitCnt,
        userCnt,
        bookmarkCnt,
        bookmarkYn,
        registeredAt,
        categoryName,
        categoryValue,
        tagName,
        tagValue,
        weekUserCertCnt,
        certCode,
      ];
}
