import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/model/comment_model.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String DELETED_MSG = '삭제된 메시지입니다.';

class CommentBox extends StatelessWidget {
  const CommentBox({
    super.key,
    required this.comment,
    required this.removeComment,
  });

  final CommentResponse comment;
  final Future<void> Function(int value) removeComment;

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final state = BlocProvider.of<UserBloc>(context).state.result;
        return FilterBottomSheetLayout(
          child: Column(
            children: [
              if (comment.userId == state!.id)
                ListTile(
                  title: Text('삭제하기', style: context.body2()),
                  onTap: () async {
                    await removeComment(comment.commentId);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                title: Text('신고하기', style: context.body2()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReportScreen(userId: comment.userId),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
                      onTap: () {
                        _openBottomSheet(context);
                      },
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
                comment.content == DELETED_MSG
                    ? Text(
                        comment.content,
                        style: context.body4(
                          color: AppColors.systemGrey3,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.systemGrey3,
                        ),
                      )
                    : Text(comment.content),
                const SizedBox(height: 6),
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
                    // Row(
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {},
                    //       style: TextButton.styleFrom(
                    //         minimumSize: Size.zero,
                    //         padding: const EdgeInsets.all(4),
                    //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //       ),
                    //       child: Text(
                    //         '답글 달기',
                    //         style: context.caption(
                    //           fontWeight: FontWeight.bold,
                    //           color: AppColors.orange,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
