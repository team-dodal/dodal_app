import 'package:dodal_app/model/user_model.dart';

class SignUpResponse {
  final String? accessToken, refreshToken;
  final User user;

  SignUpResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> data) {
    return SignUpResponse(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
      user: User.formJson(data),
    );
  }
}

class SignInResponse {
  final String? accessToken, refreshToken;
  final bool isSigned;
  final User user;

  SignInResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.isSigned,
    required this.user,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> data) {
    return SignInResponse(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
      isSigned: data['is_signed']!.toLowerCase() == 'true',
      user: User.formJson(data),
    );
  }
}

class UsersRoomFeedResponse {
  final List<UsersChallengeRoom> challengeRoomList;
  final int? maxContinueCertCnt;
  final int? totalCertCnt;

  UsersRoomFeedResponse({
    required this.challengeRoomList,
    required this.maxContinueCertCnt,
    required this.totalCertCnt,
  });

  factory UsersRoomFeedResponse.fromJson(Map<String, dynamic> data) {
    List<UsersChallengeRoom> challengeRoomList = [];
    if (data['challenge_room_list'] != null) {
      data['challenge_room_list'].forEach((challengeRoom) {
        challengeRoomList.add(UsersChallengeRoom.fromJson(challengeRoom));
      });
    }
    return UsersRoomFeedResponse(
      challengeRoomList: challengeRoomList,
      maxContinueCertCnt: data['max_continue_cert_cnt'],
      totalCertCnt: data['total_cert_cnt'],
    );
  }
}

class UsersChallengeRoom {
  final int? roomId;
  final String? title;

  UsersChallengeRoom({required this.roomId, required this.title});

  factory UsersChallengeRoom.fromJson(Map<String, dynamic> json) {
    return UsersChallengeRoom(roomId: json['room_id'], title: json['title']);
  }
}

class FeedListByDateResponse {
  final int? userId;
  final List<MyPageCalenderInfo>? myPageCalenderInfoList;

  FeedListByDateResponse({
    required this.userId,
    required this.myPageCalenderInfoList,
  });

  factory FeedListByDateResponse.fromJson(Map<String, dynamic> json) {
    List<MyPageCalenderInfo> myPageCalenderInfoList = [];
    if (json['my_page_calender_info_list'] != null) {
      json['my_page_calender_info_list'].forEach((v) {
        myPageCalenderInfoList.add(MyPageCalenderInfo.fromJson(v));
      });
    }
    return FeedListByDateResponse(
      userId: json['user_id'],
      myPageCalenderInfoList: myPageCalenderInfoList,
    );
  }
}

class MyPageCalenderInfo {
  final int feedId;
  final String certImageUrl;
  final String day;

  MyPageCalenderInfo({
    required this.feedId,
    required this.certImageUrl,
    required this.day,
  });

  factory MyPageCalenderInfo.fromJson(Map<String, dynamic> json) {
    return MyPageCalenderInfo(
      feedId: json['feed_id'],
      certImageUrl: json['cert_image_url'],
      day: json['day'],
    );
  }
}
