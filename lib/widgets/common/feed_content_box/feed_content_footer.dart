import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/providers/comment_bloc.dart';
import 'package:dodal_app/screens/comment/main.dart';
import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/model/feed_content_model.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class FeedContentFooter extends StatefulWidget {
  const FeedContentFooter({super.key, required this.feedContent});

  final FeedContent feedContent;

  @override
  State<FeedContentFooter> createState() => _FeedContentFooterState();
}

class _FeedContentFooterState extends State<FeedContentFooter> {
  like(bool value) async {
    final res = await FeedService.feedLike(
      feedId: widget.feedContent.feedId,
      value: value,
    );
    if (res == null) return;
    setState(() {
      widget.feedContent.copyWith(
        likeYn: value,
        likeCnt: value
            ? widget.feedContent.likeCnt + 1
            : widget.feedContent.likeCnt - 1,
      );
    });
  }

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterBottomSheetLayout(
          child: Column(
            children: [
              ListTile(
                title: Text('신고하기', style: context.body2()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReportScreen(userId: widget.feedContent.userId),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AvatarImage(
                    image: widget.feedContent.profileUrl,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.feedContent.nickname,
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                onPressed: _showBottomSheet,
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.systemGrey2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.feedContent.certContent),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.systemGrey4,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        iconSize: 20,
                        color: AppColors.systemGrey1,
                        style: IconButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          like(!widget.feedContent.likeYn);
                        },
                        icon: widget.feedContent.likeYn
                            ? const Icon(
                                Icons.favorite_rounded,
                                color: AppColors.orange,
                              )
                            : const Icon(Icons.favorite_border_rounded),
                      ),
                      Text(
                        '${widget.feedContent.likeCnt}',
                        style: context.body2(color: AppColors.systemGrey1),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      IconButton(
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    CommentBloc(widget.feedContent.feedId),
                                child: const CommentScreen(),
                              ),
                            ),
                          ).then((value) {
                            setState(() {
                              widget.feedContent.copyWith(commentCnt: value);
                            });
                          });
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/chat_icon.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.systemGrey1,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.feedContent.commentCnt}',
                        style: context.body2(color: AppColors.systemGrey1),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                widget.feedContent.registerCode,
                style: context.body4(
                  fontWeight: FontWeight.w400,
                  color: AppColors.systemGrey1,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
