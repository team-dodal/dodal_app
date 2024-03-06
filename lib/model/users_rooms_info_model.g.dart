// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_rooms_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersRoomsInfo _$UsersRoomsInfoFromJson(Map<String, dynamic> json) =>
    UsersRoomsInfo(
      challengeRoomList: UsersRoomsInfo.createUsersChallengeListByJsonList(
          json['challenge_room_list'] as List?),
      maxContinueCertCnt: json['max_continue_cert_cnt'] as int? ?? 0,
      totalCertCnt: json['total_cert_cnt'] as int? ?? 0,
    );

Map<String, dynamic> _$UsersRoomsInfoToJson(UsersRoomsInfo instance) =>
    <String, dynamic>{
      'max_continue_cert_cnt': instance.maxContinueCertCnt,
      'total_cert_cnt': instance.totalCertCnt,
      'challenge_room_list':
          instance.challengeRoomList.map((e) => e.toJson()).toList(),
    };

UsersChallengeRoom _$UsersChallengeRoomFromJson(Map<String, dynamic> json) =>
    UsersChallengeRoom(
      roomId: json['room_id'] as int,
      title: json['title'] as String,
    );

Map<String, dynamic> _$UsersChallengeRoomToJson(UsersChallengeRoom instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'title': instance.title,
    };
