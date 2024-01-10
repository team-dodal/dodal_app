import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/model/day_enum.dart';
import 'package:dodal_app/model/tag_model.dart';

class OneChallengeResponse {
  final int id;
  final String? thumbnailImgUrl;
  final Tag tag;
  final int certCnt;
  final String title;
  final int hostId;
  final String hostNickname;
  final String? hostProfileUrl;
  final int userCnt;
  final int recruitCnt;
  final String content;
  final List<dynamic> feedUrlList;
  final String certContent;
  final String? certCorrectImgUrl;
  final String? certWrongImgUrl;
  final int bookmarkCnt;
  final bool isBookmarked;
  final bool isJoin;
  final CertCode? todayCertCode;
  final int accuseCnt;
  final String? noticeTitle;
  final String? noticeContent;
  final DateTime? registeredAt;
  final List<UserCertPerWeek> userCertPerWeekList;
  final int? continueCertCnt;

  OneChallengeResponse({
    required this.id,
    required this.thumbnailImgUrl,
    required this.tag,
    required this.certCnt,
    required this.title,
    required this.hostId,
    required this.hostNickname,
    required this.hostProfileUrl,
    required this.userCnt,
    required this.recruitCnt,
    required this.content,
    required this.feedUrlList,
    required this.certContent,
    required this.certCorrectImgUrl,
    required this.certWrongImgUrl,
    required this.bookmarkCnt,
    required this.isBookmarked,
    required this.isJoin,
    required this.todayCertCode,
    required this.accuseCnt,
    required this.noticeTitle,
    required this.noticeContent,
    required this.registeredAt,
    required this.userCertPerWeekList,
    required this.continueCertCnt,
  });

  factory OneChallengeResponse.fromJson(Map<String, dynamic> data) {
    return OneChallengeResponse(
      id: data['room_id'],
      thumbnailImgUrl: data['thumbnail_img_url'],
      tag: Tag(name: data['tag_name'], value: data['tag_value']),
      certCnt: data['cert_cnt'],
      title: data['title'],
      hostId: data['host_id'],
      hostNickname: data['host_nickname'],
      hostProfileUrl: data['host_profile_url'],
      userCnt: data['user_cnt'],
      recruitCnt: data['recruit_cnt'],
      content: data['content'],
      feedUrlList: data['feed_url_list'],
      certContent: data['cert_content'],
      certCorrectImgUrl: data['cert_correct_img_url'],
      certWrongImgUrl: data['cert_wrong_img_url'],
      bookmarkCnt: data['bookmark_cnt'],
      isBookmarked: data['bookmark_yn'] == 'Y',
      isJoin: data['join_yn'] == 'Y',
      todayCertCode: data['today_cert_code'] != null
          ? CertCode.values[int.parse(data['today_cert_code'])]
          : null,
      accuseCnt: data['accuse_cnt'],
      noticeTitle: data['notice_title'],
      noticeContent: data['notice_content'],
      registeredAt: data['registered_at'] != null
          ? DateTime.parse(data['registered_at'])
          : null,
      userCertPerWeekList: data['user_cert_per_week_list'] != null
          ? (data['user_cert_per_week_list'] as List)
              .map((weekItem) => UserCertPerWeek.fromJson(weekItem))
              .toList()
          : [],
      continueCertCnt: data['continue_cert_cnt'] != null
          ? int.parse(data['continue_cert_cnt'])
          : null,
    );
  }
}

class UserCertPerWeek {
  DayEnum? day;
  String? certImgUrl;

  UserCertPerWeek({this.day, this.certImgUrl});

  factory UserCertPerWeek.fromJson(Map<String, dynamic> json) {
    return UserCertPerWeek(
      day: DayEnum.values[json['day_code']],
      certImgUrl: json['cert_img_url'],
    );
  }
}

class ChallengeRoomNoticeResponse {
  final int notiId;
  final int roomId;
  final String title;
  final String content;
  final String date;

  ChallengeRoomNoticeResponse({
    required this.notiId,
    required this.roomId,
    required this.title,
    required this.content,
    required this.date,
  });

  factory ChallengeRoomNoticeResponse.fromJson(Map<String, dynamic> data) {
    return ChallengeRoomNoticeResponse(
      notiId: data['noti_id'],
      roomId: data['room_id'],
      title: data['title'],
      content: data['content'],
      date: data['date'],
    );
  }
}

class ChallengeRankResponse {
  final int userId;
  final String nickname;
  final int certCnt;
  final String? profileUrl;

  ChallengeRankResponse({
    required this.userId,
    required this.nickname,
    required this.certCnt,
    required this.profileUrl,
  });

  factory ChallengeRankResponse.fromJson(Map<String, dynamic> data) {
    return ChallengeRankResponse(
      userId: data['user_id'],
      nickname: data['nickname'],
      profileUrl: data['profile_url'],
      certCnt: data['cert_cnt'],
    );
  }
}
