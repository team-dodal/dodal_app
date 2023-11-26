import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/comment/bottom_text_input.dart';
import 'package:dodal_app/widgets/comment/comment_box.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.feedId});

  final int feedId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<CommentResponse> _list = [];
  TextEditingController textEditingController = TextEditingController();

  _getCommentList() async {
    final res = await FeedService.getAllComments(feedId: widget.feedId);
    setState(() {
      _list = res;
    });
  }

  _postComment() async {
    if (textEditingController.text.isEmpty) return;
    final res = await FeedService.createComment(
      feedId: widget.feedId,
      content: textEditingController.text,
    );
    setState(() {
      _list = res;
    });
    textEditingController.clear();
  }

  Future<void> _removeComment(commentId) async {
    final res = await FeedService.removeComment(commentId: commentId);
    setState(() {
      _list = res;
    });
  }

  @override
  void initState() {
    _getCommentList();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('댓글')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              width: double.infinity,
              color: AppColors.basicColor2,
            );
          },
          itemCount: _list.length,
          itemBuilder: (context, index) => CommentBox(
            comment: _list[index],
            removeComment: _removeComment,
          ),
        ),
      ),
      bottomSheet: BottomTextInput(
        controller: textEditingController,
        postComment: () async {
          await _postComment();
        },
      ),
    );
  }
}
