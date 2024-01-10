import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';

class SignUpResponse {
  final String? accessToken, refreshToken;

  SignUpResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> data) {
    return SignUpResponse(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
    );
  }
}

class SignInResponse extends User {
  final String? accessToken, refreshToken;
  final bool isSigned;

  SignInResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'],
        isSigned = data['is_signed']!.toLowerCase() == 'true',
        super.formJson(data);
}

class UserResponse {
  final int? userId;
  final String? nickname;
  final String? profileUrl;
  final String? content;
  final List<Category>? categoryList;
  final List<Tag>? tagList;
  final List<ChallengeRoomList>? challengeRoomList;
  final int? maxContinueCertCnt;
  final int? totalCertCnt;

  UserResponse({
    required this.userId,
    required this.nickname,
    required this.profileUrl,
    required this.content,
    required this.categoryList,
    required this.tagList,
    required this.challengeRoomList,
    required this.maxContinueCertCnt,
    required this.totalCertCnt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> data) {
    List<Category> categoryList = [];
    List<Tag> tagList = [];
    List<ChallengeRoomList> challengeRoomList = [];
    if (data['category_list'] != null) {
      data['category_list'].forEach((category) {
        categoryList.add(Category(
          name: category['name'],
          subName: category['sub_name'],
          value: category['value'],
          emoji: category['emoji'],
          tags: [],
        ));
      });
    }
    if (data['tag_list'] != null) {
      data['tag_list'].forEach((tag) {
        tagList.add(Tag(name: tag['name'], value: tag['value']));
      });
    }
    if (data['challenge_room_list'] != null) {
      data['challenge_room_list'].forEach((challengeRoom) {
        challengeRoomList.add(ChallengeRoomList.fromJson(challengeRoom));
      });
    }
    return UserResponse(
      userId: data['user_id'],
      nickname: data['nickname'],
      profileUrl: data['profile_url'],
      content: data['content'],
      maxContinueCertCnt: data['max_continue_cert_cnt'],
      totalCertCnt: data['total_cert_cnt'],
      categoryList: categoryList,
      challengeRoomList: challengeRoomList,
      tagList: tagList,
    );
  }
}

class ChallengeRoomList {
  final int? roomId;
  final String? title;

  ChallengeRoomList({required this.roomId, required this.title});

  factory ChallengeRoomList.fromJson(Map<String, dynamic> json) {
    return ChallengeRoomList(roomId: json['room_id'], title: json['title']);
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
