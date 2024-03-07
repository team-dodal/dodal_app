import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_rank_model.g.dart';

@JsonSerializable()
class ChallengeRank extends Equatable {
  @JsonKey(name: 'user_id')
  final int userId;
  final String nickname;
  @JsonKey(name: 'cert_cnt')
  final int certCnt;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;

  const ChallengeRank({
    required this.userId,
    required this.nickname,
    required this.certCnt,
    required this.profileUrl,
  });

  factory ChallengeRank.fromJson(Map<String, dynamic> json) =>
      _$ChallengeRankFromJson(json);

  @override
  List<Object?> get props => [userId, nickname, certCnt, profileUrl];
}
