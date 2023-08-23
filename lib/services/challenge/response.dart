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
  final String todayCertCode;
  final int accuseCnt;
  final String? noticeTitle;
  final String? noticeContent;
  final DateTime? registeredAt;

  OneChallengeResponse.fromJson(Map<String, dynamic> data)
      : id = data['room_id'],
        thumbnailImgUrl = data['thumbnail_img_url'],
        tag = Tag(name: data['tag_name'], value: data['tag_value']),
        certCnt = data['cert_cnt'],
        title = data['title'],
        hostId = data['host_id'],
        hostNickname = data['host_nickname'],
        hostProfileUrl = data['host_profile_url'],
        userCnt = data['user_cnt'],
        recruitCnt = data['recruit_cnt'],
        content = data['content'],
        feedUrlList = data['feed_url_list'],
        certContent = data['cert_content'],
        certCorrectImgUrl = data['cert_correct_img_url'],
        certWrongImgUrl = data['cert_wrong_img_url'],
        bookmarkCnt = data['bookmark_cnt'],
        isBookmarked = data['bookmark_yn'] == 'Y',
        isJoin = data['join_yn'] == 'Y',
        todayCertCode = data['today_cert_code'],
        accuseCnt = data['accuse_cnt'],
        noticeTitle = data['notice_title'],
        noticeContent = data['notice_content'],
        registeredAt = data['registered_at'] != null
            ? DateTime.parse(data['registered_at'])
            : null;
}

class ChallengeRoomNotiResponse {
  final int notiId;
  final int roomId;
  final String title;
  final String content;
  final DateTime? date;

  ChallengeRoomNotiResponse({
    required this.notiId,
    required this.roomId,
    required this.title,
    required this.content,
    required this.date,
  });

  ChallengeRoomNotiResponse.fromJson(Map<String, dynamic> data)
      : notiId = data['noti_id'],
        roomId = data['room_id'],
        title = data['title'],
        content = data['content'],
        date =
            data['date'] != null ? DateTime.parse(data['registered_at']) : null;
}
