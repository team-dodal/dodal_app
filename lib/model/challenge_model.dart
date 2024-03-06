import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_model.g.dart';

@JsonSerializable()
class Challenge extends Equatable {
  @JsonKey(name: 'challenge_room_id')
  final int id;
  @JsonKey(name: 'host_id')
  final int adminId;
  @JsonKey(name: 'host_nickname')
  final String adminNickname;
  @JsonKey(name: 'host_profile_url')
  final String? adminProfile;
  final String title;
  final String content;
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
  @JsonKey(name: 'bookmark_yn', fromJson: isTrue, defaultValue: 0)
  final bool isBookmarked;
  @JsonKey(name: 'join_yn', fromJson: isTrue)
  final bool isJoined;
  @JsonKey(name: 'registered_at', fromJson: DateTime.parse)
  final DateTime registeredAt;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'category_value')
  final String categoryValue;
  @JsonKey(name: 'tag_name')
  final dynamic tagName;
  @JsonKey(name: 'tag_value')
  final dynamic tagValue;
  Tag get tag => Tag(name: tagName, value: tagValue);

  const Challenge({
    required this.id,
    required this.adminId,
    required this.adminNickname,
    required this.adminProfile,
    required this.title,
    required this.content,
    required this.certCnt,
    required this.thumbnailImg,
    required this.recruitCnt,
    required this.userCnt,
    required this.bookmarkCnt,
    required this.isBookmarked,
    required this.isJoined,
    required this.registeredAt,
    required this.categoryName,
    required this.categoryValue,
    required this.tagName,
    required this.tagValue,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  static isTrue(value) => value == 'Y';

  @override
  List<Object?> get props => [
        id,
        adminId,
        adminNickname,
        adminProfile,
        title,
        content,
        certCnt,
        thumbnailImg,
        recruitCnt,
        userCnt,
        bookmarkCnt,
        isBookmarked,
        isJoined,
        registeredAt,
        categoryName,
        categoryValue,
        tagName,
        tagValue
      ];
}
