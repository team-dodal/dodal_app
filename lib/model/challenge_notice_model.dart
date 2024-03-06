import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_notice_model.g.dart';

@JsonSerializable()
class ChallengeNotice extends Equatable {
  @JsonKey(name: 'noti_id')
  final int id;
  @JsonKey(name: 'room_id')
  final int roomId;
  final String title;
  final String content;
  final String date;

  const ChallengeNotice({
    required this.id,
    required this.roomId,
    required this.title,
    required this.content,
    required this.date,
  });

  factory ChallengeNotice.fromJson(Map<String, dynamic> json) =>
      _$ChallengeNoticeFromJson(json);

  @override
  List<Object?> get props => [id, roomId, title, content, date];
}
