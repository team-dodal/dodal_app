import 'package:dodal_app/model/tag_model.dart';

class Challenge {
  final int id;
  final int adminId;
  final String adminNickname;
  final String? adminProfile;
  final String title;
  final int certCnt;
  final String? thumbnailImg;
  final int recruitCnt;
  final int userCnt;
  final int bookmarkCnt;
  final bool bookmarkStatus;
  final DateTime registeredAt;
  final String categoryName;
  final String categoryValue;
  final Tag tag;

  Challenge.fromJson(Map<String, dynamic> data)
      : id = data['challenge_room_id'],
        adminId = data['user_id'],
        adminNickname = data['nickname'],
        adminProfile = data['profile_url'],
        title = data['title'],
        certCnt = data['cert_cnt'],
        thumbnailImg = data['thumbnail_img_url'],
        recruitCnt = data['recruit_cnt'],
        userCnt = data['user_cnt'],
        bookmarkCnt = data['bookmark_cnt'],
        bookmarkStatus = data['bookmark_yn'] == 'Y' ? true : false,
        registeredAt = DateTime.parse(data['registered_at']),
        categoryName = data['category_name'],
        categoryValue = data['category_value'],
        tag = Tag(name: data['tag_name'], value: data['tag_value']);
}
