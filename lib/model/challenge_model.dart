import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';

class Challenge extends Equatable {
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
  final DateTime? registeredAt;
  final String categoryName;
  final String categoryValue;
  final Tag tag;

  Challenge.fromJson(Map<String, dynamic> data)
      : id = data['challenge_room_id'],
        adminId = data['host_id'],
        adminNickname = data['host_nickname'],
        adminProfile = data['host_profile_url'],
        title = data['title'],
        certCnt = data['cert_cnt'],
        thumbnailImg = data['thumbnail_img_url'],
        recruitCnt = data['recruit_cnt'],
        userCnt = data['user_cnt'],
        bookmarkCnt = data['bookmark_cnt'],
        bookmarkStatus = data['bookmark_yn'] == 'Y' ? true : false,
        registeredAt = data['registered_at']
            ? DateTime.parse(data['registered_at'])
            : null,
        categoryName = data['category_name'],
        categoryValue = data['category_value'],
        tag = Tag(name: data['tag_name'], value: data['tag_value']);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        adminId,
        adminNickname,
        adminProfile.toString(),
        title,
        certCnt,
        thumbnailImg.toString(),
        recruitCnt,
        userCnt,
        bookmarkCnt,
        bookmarkStatus,
        registeredAt.toString(),
        categoryName,
        categoryValue,
        tag,
      ];
}
