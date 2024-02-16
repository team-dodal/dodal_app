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

  JoinedChallengesResponse({
    required this.id,
    required this.adminId,
    required this.adminNickname,
    required this.adminProfileUrl,
    required this.title,
    required this.certCnt,
    required this.thumbnailImg,
    required this.recruitCnt,
    required this.userCnt,
    required this.bookmarkCnt,
    required this.bookmarkYn,
    required this.registeredAt,
    required this.categoryName,
    required this.categoryValue,
    required this.tag,
    required this.weekUserCertCnt,
    required this.certCode,
  });

  factory JoinedChallengesResponse.fromJson(Map<String, dynamic> data) {
    return JoinedChallengesResponse(
      id: data['challenge_room_id'],
      adminId: data['user_id'],
      adminNickname: data['nickname'],
      adminProfileUrl: data['profile_url'],
      title: data['title'],
      certCnt: data['cert_cnt'],
      thumbnailImg: data['thumbnail_img_url'],
      recruitCnt: data['recruit_cnt'],
      userCnt: data['user_cnt'],
      bookmarkCnt: data['bookmark_cnt'],
      bookmarkYn: data['bookmark_yn'] == 'Y',
      registeredAt: data['registered_at'] != null
          ? DateTime.parse(data['registered_at'])
          : null,
      categoryName: data['category_name'],
      categoryValue: data['category_value'],
      tag: Tag(name: data['tag_name'], value: data['tag_value']),
      weekUserCertCnt: data['week_user_cert_cnt'],
      certCode: data['cert_code'] != null
          ? CertCode.values[int.parse(data['cert_code'])]
          : null,
    );
  }
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

  HostChallengesResponse({
    required this.challengeRoomId,
    required this.userId,
    required this.nickname,
    required this.profileUrl,
    required this.title,
    required this.certCnt,
    required this.thumbnailImgUrl,
    required this.recruitCnt,
    required this.userCnt,
    required this.bookmarkCnt,
    required this.bookmarkYn,
    required this.registeredAt,
    required this.categoryName,
    required this.categoryValue,
    required this.tag,
    required this.certRequestCnt,
  });

  factory HostChallengesResponse.fromJson(Map<String, dynamic> data) {
    return HostChallengesResponse(
      challengeRoomId: data['challenge_room_id'],
      userId: data['user_id'],
      nickname: data['nickname'],
      profileUrl: data['profile_url'],
      title: data['title'],
      certCnt: data['cert_cnt'],
      thumbnailImgUrl: data['thumbnail_img_url'],
      recruitCnt: data['recruit_cnt'],
      userCnt: data['user_cnt'],
      bookmarkCnt: data['bookmark_cnt'],
      bookmarkYn: data['bookmark_yn'] == 'Y',
      registeredAt: data['registered_at'] != null
          ? DateTime.parse(data['registered_at'])
          : null,
      categoryName: data['category_name'],
      categoryValue: data['category_value'],
      tag: Tag(name: data['tag_name'], value: data['tag_value']),
      certRequestCnt: data['cert_request_cnt'],
    );
  }
}

class FeedItem {
  final int? challengeRoomId;
  final int? challengeFeedId;
  final int? requestUserId;
  final String? requestUserNickname;
  final String? certImageUrl;
  final String? certContent;
  final String? certCode;
  final String? registeredAt;
  final String? registeredDate;

  FeedItem({
    this.challengeRoomId,
    this.challengeFeedId,
    this.requestUserId,
    this.requestUserNickname,
    this.certImageUrl,
    this.certContent,
    this.certCode,
    this.registeredAt,
    this.registeredDate,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      challengeRoomId: json['challenge_room_id'],
      challengeFeedId: json['challenge_feed_id'],
      requestUserId: json['request_user_id'],
      requestUserNickname: json['request_user_nickname'],
      certImageUrl: json['cert_image_url'],
      certContent: json['cert_content'],
      certCode: json['cert_code'],
      registeredAt: json['registered_at'],
      registeredDate: json['registered_date'],
    );
  }
}

class ChallengeUser {
  final int challengeRoomId;
  final int userId;
  final String nickname;
  final String? profileUrl;
  final int? certSuccessCnt;
  final int? certFailCnt;
  final List<UserWeekCertInfo>? userWeekCertInfoList;

  ChallengeUser({
    required this.challengeRoomId,
    required this.userId,
    required this.nickname,
    required this.profileUrl,
    required this.certSuccessCnt,
    required this.certFailCnt,
    required this.userWeekCertInfoList,
  });

  factory ChallengeUser.fromJson(Map<String, dynamic> json) {
    return ChallengeUser(
      challengeRoomId: json['challenge_room_id'],
      userId: json['user_id'],
      nickname: json['nickname'],
      profileUrl: json['profile_url'],
      certSuccessCnt: json['cert_success_cnt'],
      certFailCnt: json['cert_fail_cnt'],
      userWeekCertInfoList: json['user_week_cert_info_list'] != null
          ? (json['user_week_cert_info_list'] as List)
              .map((weekItem) => UserWeekCertInfo.fromJson(weekItem))
              .toList()
          : [],
    );
  }
}

class UserWeekCertInfo {
  final int? feedId;
  final String? certImageUrl;
  final CertCode? certCode;
  final DayEnum? dayCode;

  UserWeekCertInfo({
    required this.feedId,
    required this.certImageUrl,
    required this.certCode,
    required this.dayCode,
  });

  factory UserWeekCertInfo.fromJson(Map<String, dynamic> json) {
    return UserWeekCertInfo(
      feedId: json['feed_id'],
      certImageUrl: json['cert_image_url'],
      certCode: CertCode.values[int.parse(json['cert_code'])],
      dayCode: DayEnum.values[(int.parse(json['day_code']))],
    );
  }
}
