import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentResponse extends Equatable {
  @JsonKey(name: 'comment_id')
  final int commentId;
  @JsonKey(name: 'feed_id')
  final int feedId;
  @JsonKey(name: 'user_id')
  final int userId;
  final String nickname;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;
  @JsonKey(name: 'parent_id')
  final int? parentId;
  final String content;
  @JsonKey(name: 'register_code')
  final String registerCode;
  @JsonKey(name: 'registered_at')
  final String registeredAt;
  @JsonKey(fromJson: createCommentListByJsonList)
  final List<CommentResponse> children;

  const CommentResponse({
    required this.commentId,
    required this.feedId,
    required this.userId,
    required this.nickname,
    required this.profileUrl,
    required this.parentId,
    required this.content,
    required this.registerCode,
    required this.registeredAt,
    required this.children,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommentResponseToJson(this);

  static List<CommentResponse> createCommentListByJsonList(
          List<dynamic> value) =>
      value.map((e) => CommentResponse.fromJson(e)).toList();

  @override
  List<Object?> get props => [
        commentId,
        feedId,
        userId,
        nickname,
        profileUrl,
        parentId,
        content,
        registerCode,
        registeredAt,
        children
      ];
}
