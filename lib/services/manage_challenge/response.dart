import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/model/day_enum.dart';
import 'package:dodal_app/model/tag_model.dart';

class JoinedChallengesResponse {
  final int id;
  final int adminId;
  final String adminNickname;
  final String? adminProfileUrl;
  final String title;
  final int certCnt;
  final String? thumbnailImg;
  final int recruitCnt;
  final int userCnt;
  final int bookmarkCnt;
  final bool bookmarkYn;
  final DateTime? registeredAt;
  final String categoryName;
  final String categoryValue;
  final Tag tag;
  final int weekUserCertCnt;
  final CertCode? certCode;

  JoinedChallengesResponse.fromJson(Map<String, dynamic> data)
      : id = data['challenge_room_id'],
        adminId = data['user_id'],
        adminNickname = data['nickname'],
        adminProfileUrl = data['profile_url'],
        title = data['title'],
        certCnt = data['cert_cnt'],
        thumbnailImg = data['thumbnail_img_url'],
        recruitCnt = data['recruit_cnt'],
        userCnt = data['user_cnt'],
        bookmarkCnt = data['bookmark_cnt'],
        bookmarkYn = data['bookmark_yn'] == 'Y',
        registeredAt = data['registered_at'] != null
            ? DateTime.parse(data['registered_at'])
            : null,
        categoryName = data['category_name'],
        categoryValue = data['category_value'],
        tag = Tag(name: data['tag_name'], value: data['tag_value']),
        weekUserCertCnt = data['week_user_cert_cnt'],
        certCode = data['cert_code'] != null
            ? CertCode.values[int.parse(data['cert_code'])]
            : null;
}

class HostChallengesResponse {
  final int challengeRoomId;
  final int userId;
  final String nickname;
  final String? profileUrl;
  final String title;
  final int certCnt;
  final String? thumbnailImgUrl;
  final int recruitCnt;
  final int userCnt;
  final int bookmarkCnt;
  final bool bookmarkYn;
  final DateTime? registeredAt;
  final String categoryName;
  final String categoryValue;
  final Tag tag;
  final int certRequestCnt;

  HostChallengesResponse.fromJson(Map<String, dynamic> data)
      : challengeRoomId = data['challenge_room_id'],
        userId = data['user_id'],
        nickname = data['nickname'],
        profileUrl = data['profile_url'],
        title = data['title'],
        certCnt = data['cert_cnt'],
        thumbnailImgUrl = data['thumbnail_img_url'],
        recruitCnt = data['recruit_cnt'],
        userCnt = data['user_cnt'],
        bookmarkCnt = data['bookmark_cnt'],
        bookmarkYn = data['bookmark_yn'] == 'Y',
        registeredAt = data['registered_at'] != null
            ? DateTime.parse(data['registered_at'])
            : null,
        categoryName = data['category_name'],
        categoryValue = data['category_value'],
        tag = Tag(name: data['tag_name'], value: data['tag_value']),
        certRequestCnt = data['cert_request_cnt'];
}

class FeedItem {
  int? challengeRoomId;
  int? challengeFeedId;
  int? requestUserId;
  String? requestUserNickname;
  String? certImageUrl;
  String? certContent;
  String? certCode;
  String? registeredAt;
  String? registeredDate;

  FeedItem(
      {this.challengeRoomId,
      this.challengeFeedId,
      this.requestUserId,
      this.requestUserNickname,
      this.certImageUrl,
      this.certContent,
      this.certCode,
      this.registeredAt,
      this.registeredDate});

  FeedItem.fromJson(Map<String, dynamic> json) {
    challengeRoomId = json['challenge_room_id'];
    challengeFeedId = json['challenge_feed_id'];
    requestUserId = json['request_user_id'];
    requestUserNickname = json['request_user_nickname'];
    certImageUrl = json['cert_image_url'];
    certContent = json['cert_content'];
    certCode = json['cert_code'];
    registeredAt = json['registered_at'];
    registeredDate = json['registered_date'];
  }
}

class ChallengeUser {
  int challengeRoomId;
  int userId;
  String nickname;
  String? profileUrl;
  int? certSuccessCnt;
  int? certFailCnt;
  List<UserWeekCertInfo>? userWeekCertInfoList;

  ChallengeUser.fromJson(Map<String, dynamic> json)
      : challengeRoomId = json['challenge_room_id'],
        userId = json['user_id'],
        nickname = json['nickname'],
        profileUrl = json['profile_url'],
        certSuccessCnt = json['cert_success_cnt'],
        certFailCnt = json['cert_fail_cnt'],
        userWeekCertInfoList = json['user_cert_per_week_list'] != null
            ? (json['user_cert_per_week_list'] as List)
                .map((weekItem) => UserWeekCertInfo.fromJson(weekItem))
                .toList()
            : [];
}

class UserWeekCertInfo {
  int? feedId;
  String? certImageUrl;
  CertCode? certCode;
  DayEnum? dayCode;

  UserWeekCertInfo({
    this.feedId,
    this.certImageUrl,
    this.certCode,
    this.dayCode,
  });

  UserWeekCertInfo.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    certImageUrl = json['cert_image_url'];
    certCode = CertCode.values[int.parse(json['cert_code'])];
    dayCode = DayEnum.values[(int.parse(json['day_code']))];
  }
}
