class FeedContentResponse {
  final int roomId;
  final int feedId;
  final int certCnt;
  final String title;
  final String categoryName;
  final int userId;
  final String nickname;
  final int continueCertCnt;
  final String certImgUrl;
  final String certContent;
  final int likeCnt;
  final int accuseCnt;
  final bool likeYn;
  final bool joinYn;
  final DateTime registeredAt;

  FeedContentResponse.fromJson(dynamic data)
      : roomId = data['room_id'],
        feedId = data['feed_id'],
        certCnt = data['cert_cnt'],
        title = data['title'],
        categoryName = data['category_name'],
        userId = data['user_id'],
        nickname = data['nickname'],
        continueCertCnt = data['continue_cert_cnt'],
        certImgUrl = data['cert_img_url'],
        certContent = data['cert_content'],
        likeCnt = data['like_cnt'],
        accuseCnt = data['accuse_cnt'],
        likeYn = data['like_yn'] == 'Y',
        joinYn = data['join_yn'] == 'Y',
        registeredAt = DateTime.parse(data['registered_at']);
}
