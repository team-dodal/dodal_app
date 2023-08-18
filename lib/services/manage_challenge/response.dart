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
  final String certCode;

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
        certCode = data['cert_code'];
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
