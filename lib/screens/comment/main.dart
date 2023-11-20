import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.feedId});

  final int feedId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<CommentResponse> _list = [];

  _getCommentList() async {
    final res = await FeedService.getAllComments(feedId: 1);
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
          itemBuilder: (context, index) {
            CommentResponse comment = _list[index];
            return SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarImage(
                    image: comment.profileUrl,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.nickname,
                              style: context.body4(fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {},
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.more_vert_rounded,
                                color: AppColors.systemGrey2,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(comment.content),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.registerCode,
                              style: context.caption(
                                fontWeight: FontWeight.normal,
                                color: AppColors.systemGrey1,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '답글 달기',
                                    style: context.caption(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
