import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_calendar_data_model.g.dart';

@JsonSerializable()
class UserCalendarData extends Equatable {
  @JsonKey(name: 'feed_id')
  final int feedId;
  @JsonKey(name: 'cert_image_url')
  final String certImageUrl;
  @JsonKey(name: 'day')
  final String day;

  const UserCalendarData({
    required this.feedId,
    required this.certImageUrl,
    required this.day,
  });

  factory UserCalendarData.fromJson(Map<String, dynamic> json) =>
      _$UserCalendarDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserCalendarDataToJson(this);

  @override
  List<Object?> get props => [feedId, certImageUrl, day];
}
