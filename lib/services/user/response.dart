import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';

class SignUpResponse {
  String? accessToken, refreshToken;

  SignUpResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'];
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
  int? userId;
  String? nickname;
  String? profileUrl;
  String? content;
  List<Category>? categoryList;
  List<Tag>? tagList;
  List<ChallengeRoomList>? challengeRoomList;
  int? maxContinueCertCnt;
  int? totalCertCnt;

  UserResponse.fromJson(Map<String, dynamic> data) {
    userId = data['user_id'];
    nickname = data['nickname'];
    profileUrl = data['profile_url'];
    content = data['content'];
    if (data['category_list'] != null) {
      categoryList = <Category>[];
      data['category_list'].forEach((category) {
        categoryList!.add(Category(
          name: category['name'],
          subName: category['sub_name'],
          value: category['value'],
          emoji: category['emoji'],
          tags: [],
        ));
      });
    }
    if (data['tag_list'] != null) {
      tagList = <Tag>[];
      data['tag_list'].forEach((tag) {
        tagList!.add(Tag(name: tag['name'], value: tag['value']));
      });
    }
    if (data['challenge_room_list'] != null) {
      challengeRoomList = <ChallengeRoomList>[];
      data['challenge_room_list'].forEach((challengeRoom) {
        challengeRoomList!.add(ChallengeRoomList.fromJson(challengeRoom));
      });
    }
    maxContinueCertCnt = data['max_continue_cert_cnt'];
    totalCertCnt = data['total_cert_cnt'];
  }
}

class ChallengeRoomList {
  final int? roomId;
  final String? title;

  ChallengeRoomList.fromJson(Map<String, dynamic> json)
      : roomId = json['room_id'],
        title = json['title'];
}

class FeedListByDateResponse {
  int? userId;
  List<MyPageCalenderInfo>? myPageCalenderInfoList;

  FeedListByDateResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    if (json['my_page_calender_info_list'] != null) {
      myPageCalenderInfoList = <MyPageCalenderInfo>[];
      json['my_page_calender_info_list'].forEach((v) {
        myPageCalenderInfoList!.add(MyPageCalenderInfo.fromJson(v));
      });
    }
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

  MyPageCalenderInfo.fromJson(Map<String, dynamic> json)
      : feedId = json['feed_id'],
        certImageUrl = json['cert_image_url'],
        day = json['day'];
}
