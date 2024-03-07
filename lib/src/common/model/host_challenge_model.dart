import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'host_challenge_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HostChallenge extends Equatable {
  @JsonKey(name: 'challenge_room_id')
  final int challengeRoomId;
  @JsonKey(name: 'user_id')
  final int userId;
  final String nickname;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;
  final String title;
  @JsonKey(name: 'cert_cnt')
  final int certCnt;
  @JsonKey(name: 'thumbnail_img_url')
  final String? thumbnailImgUrl;
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
  @JsonKey(name: 'cert_request_cnt')
  final int certRequestCnt;

  const HostChallenge({
    required this.challengeRoomId,
    required this.userId,
    required this.nickname,
    required this.profileUrl,
    required this.title,
    required this.certCnt,
    required this.thumbnailImgUrl,
    required this.recruitCnt,
    required this.userCnt,
    required this.bookmarkCnt,
    required this.bookmarkYn,
    required this.registeredAt,
    required this.categoryName,
    required this.categoryValue,
    required this.tagName,
    required this.tagValue,
    required this.certRequestCnt,
  });

  factory HostChallenge.fromJson(Map<String, dynamic> json) =>
      _$HostChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$HostChallengeToJson(this);

  get tag => Tag(name: tagName, value: tagValue);

  static isTrue(String? value) => value == 'Y';

  @override
  List<Object?> get props => [
        challengeRoomId,
        userId,
        nickname,
        profileUrl,
        title,
        certCnt,
        thumbnailImgUrl,
        recruitCnt,
        userCnt,
        bookmarkCnt,
        bookmarkYn,
        registeredAt,
        categoryName,
        categoryValue,
        tagName,
        tagValue,
        certRequestCnt,
      ];
}
