import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_rooms_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UsersRoomsInfo extends Equatable {
  @JsonKey(name: 'max_continue_cert_cnt', defaultValue: 0)
  final int maxContinueCertCnt;
  @JsonKey(name: 'total_cert_cnt', defaultValue: 0)
  final int totalCertCnt;
  @JsonKey(
      name: 'challenge_room_list', fromJson: createUsersChallengeListByJsonList)
  final List<UsersChallengeRoom> challengeRoomList;

  const UsersRoomsInfo({
    required this.challengeRoomList,
    required this.maxContinueCertCnt,
    required this.totalCertCnt,
  });

  factory UsersRoomsInfo.fromJson(Map<String, dynamic> json) =>
      _$UsersRoomsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UsersRoomsInfoToJson(this);

  static List<UsersChallengeRoom> createUsersChallengeListByJsonList(
          List? list) =>
      (list ?? [])
          .map((challengeRoom) => UsersChallengeRoom.fromJson(challengeRoom))
          .toList();

  @override
  List<Object?> get props =>
      [maxContinueCertCnt, totalCertCnt, challengeRoomList];
}

@JsonSerializable()
class UsersChallengeRoom extends Equatable {
  @JsonKey(name: 'room_id')
  final int roomId;
  final String title;

  const UsersChallengeRoom({required this.roomId, required this.title});

  factory UsersChallengeRoom.fromJson(Map<String, dynamic> json) =>
      _$UsersChallengeRoomFromJson(json);

  Map<String, dynamic> toJson() => _$UsersChallengeRoomToJson(this);

  @override
  List<Object?> get props => [roomId, title];
}
