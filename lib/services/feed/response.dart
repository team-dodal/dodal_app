class FeedContentResponse {
  final int roomId;
  final int feedId;
  final int certCnt;
  final String title;
  final String categoryName;
  final int userId;
  final String? profileUrl;
  final String nickname;
  final int continueCertCnt;
  final String certImgUrl;
  final String certContent;
  int likeCnt;
  final int accuseCnt;
  bool likeYn;
  final bool joinYn;
  final DateTime registeredAt;
  final String registerCode;
  final int commentCnt;

  FeedContentResponse.fromJson(dynamic data)
      : roomId = data['room_id'],
        feedId = data['feed_id'],
        certCnt = data['cert_cnt'],
        title = data['title'],
        categoryName = data['category_name'],
        userId = data['user_id'],
        profileUrl = data['profile_url'],
        nickname = data['nickname'],
        continueCertCnt = data['continue_cert_cnt'],
        certImgUrl = data['cert_img_url'],
        certContent = data['cert_content'],
        likeCnt = data['like_cnt'],
        accuseCnt = data['accuse_cnt'],
        likeYn = data['like_yn'] == 'Y',
        joinYn = data['join_yn'] == 'Y',
        registeredAt = DateTime.parse(data['registered_at']),
        registerCode = data['register_code'],
        commentCnt = data['comment_cnt'];
}

class CommentResponse {
  final int commentId;
  final int feedId;
  final int userId;
  final String nickname;
  final String profileUrl;
  final int? parentId;
  final String content;
  final String registerCode;
  final String registeredAt;
  final List<CommentResponse> children;

  CommentResponse.fromJson(Map<String, dynamic> data)
      : commentId = data['comment_id'],
        feedId = data['feed_id'],
        userId = data['user_id'],
        nickname = data['nickname'],
        profileUrl = data['profile_url'],
        parentId = data['parent_id'],
        content = data['content'],
        registerCode = data['register_code'],
        registeredAt = data['registered_at'],
        children = (data['children'] as List<dynamic>)
            .map((comment) => CommentResponse.fromJson(comment))
            .toList();
}
