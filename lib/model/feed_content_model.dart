import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feed_content_model.g.dart';

@JsonSerializable()
class FeedContent extends Equatable {
  @JsonKey(name: 'room_id')
  final int roomId;
  @JsonKey(name: 'feed_id')
  final int feedId;
  @JsonKey(name: 'cert_cnt')
  final int certCnt;
  final String title;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;
  final String nickname;
  @JsonKey(name: 'continue_cert_cnt')
  final int continueCertCnt;
  @JsonKey(name: 'cert_img_url')
  final String certImgUrl;
  @JsonKey(name: 'cert_content')
  final String certContent;
  @JsonKey(name: 'like_cnt')
  final int likeCnt;
  @JsonKey(name: 'accuse_cnt')
  final int accuseCnt;
  @JsonKey(name: 'like_yn', fromJson: isTrue)
  final bool likeYn;
  @JsonKey(name: 'join_yn', fromJson: isTrue, defaultValue: false)
  final bool joinYn;
  @JsonKey(name: 'registered_at', fromJson: DateTime.parse)
  final DateTime registeredAt;
  @JsonKey(name: 'register_code')
  final String registerCode;
  @JsonKey(name: 'comment_cnt')
  final int commentCnt;

  const FeedContent({
    required this.roomId,
    required this.feedId,
    required this.certCnt,
    required this.title,
    required this.categoryName,
    required this.userId,
    required this.profileUrl,
    required this.nickname,
    required this.continueCertCnt,
    required this.certImgUrl,
    required this.certContent,
    required this.accuseCnt,
    required this.joinYn,
    required this.registeredAt,
    required this.registerCode,
    required this.commentCnt,
    required this.likeCnt,
    required this.likeYn,
  });

  factory FeedContent.fromJson(Map<String, dynamic> json) =>
      _$FeedContentFromJson(json);

  static isTrue(String value) => value == 'Y';

  Map<String, dynamic> toJson() => _$FeedContentToJson(this);

  copyWith({
    int? roomId,
    int? feedId,
    int? certCnt,
    String? title,
    String? categoryName,
    int? userId,
    String? profileUrl,
    String? nickname,
    int? continueCertCnt,
    String? certImgUrl,
    String? certContent,
    int? accuseCnt,
    bool? joinYn,
    DateTime? registeredAt,
    String? registerCode,
    int? commentCnt,
    int? likeCnt,
    bool? likeYn,
  }) =>
      FeedContent(
        roomId: roomId ?? this.roomId,
        feedId: feedId ?? this.feedId,
        certCnt: certCnt ?? this.certCnt,
        title: title ?? this.title,
        categoryName: categoryName ?? this.categoryName,
        userId: userId ?? this.userId,
        profileUrl: profileUrl ?? this.profileUrl,
        nickname: nickname ?? this.nickname,
        continueCertCnt: continueCertCnt ?? this.continueCertCnt,
        certImgUrl: certImgUrl ?? this.certImgUrl,
        certContent: certContent ?? this.certContent,
        accuseCnt: accuseCnt ?? this.accuseCnt,
        joinYn: joinYn ?? this.joinYn,
        registeredAt: registeredAt ?? this.registeredAt,
        registerCode: registerCode ?? this.registerCode,
        commentCnt: commentCnt ?? this.commentCnt,
        likeCnt: likeCnt ?? this.likeCnt,
        likeYn: likeYn ?? this.likeYn,
      );

  @override
  List<Object?> get props => [
        roomId,
        feedId,
        certCnt,
        title,
        categoryName,
        userId,
        profileUrl,
        nickname,
        continueCertCnt,
        certImgUrl,
        certContent,
        accuseCnt,
        joinYn,
        registeredAt,
        registerCode,
        commentCnt,
        likeCnt,
        likeYn,
      ];
}
