import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm_content_model.g.dart';

@JsonSerializable()
class AlarmContent extends Equatable {
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'room_id')
  final int roomId;
  final String title;
  final String content;
  @JsonKey(name: 'registered_at', fromJson: DateTime.parse)
  final DateTime registeredAt;
  @JsonKey(name: 'register_code')
  final String registerCode;

  const AlarmContent({
    required this.userId,
    required this.roomId,
    required this.title,
    required this.content,
    required this.registeredAt,
    required this.registerCode,
  });

  factory AlarmContent.fromJson(Map<String, dynamic> json) =>
      _$AlarmContentFromJson(json);

  @override
  List<Object?> get props =>
      [userId, roomId, title, content, registeredAt, registerCode];
}
