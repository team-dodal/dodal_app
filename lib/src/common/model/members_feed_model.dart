import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'members_feed_model.g.dart';

@JsonSerializable()
class MembersFeed extends Equatable {
  @JsonKey(name: 'challenge_room_id')
  final int challengeRoomId;
  @JsonKey(name: 'challenge_feed_id')
  final int challengeFeedId;
  @JsonKey(name: 'request_user_id')
  final int requestUserId;
  @JsonKey(name: 'request_user_nickname')
  final String requestUserNickname;
  @JsonKey(name: 'cert_image_url')
  final String? certImageUrl;
  @JsonKey(name: 'cert_content')
  final String certContent;
  @JsonKey(name: 'cert_code')
  final String certCode;
  @JsonKey(name: 'registered_at')
  final String registeredAt;
  @JsonKey(name: 'registered_date')
  final String registeredDate;

  const MembersFeed({
    required this.challengeRoomId,
    required this.challengeFeedId,
    required this.requestUserId,
    required this.requestUserNickname,
    required this.certImageUrl,
    required this.certContent,
    required this.certCode,
    required this.registeredAt,
    required this.registeredDate,
  });

  factory MembersFeed.fromJson(Map<String, dynamic> json) =>
      _$MembersFeedFromJson(json);

  Map<String, dynamic> toJson() => _$MembersFeedToJson(this);

  @override
  List<Object?> get props => [
        challengeRoomId,
        challengeFeedId,
        requestUserId,
        requestUserNickname,
        certImageUrl,
        certContent,
        certCode,
        registeredAt,
        registeredDate
      ];
}
