import 'package:dodal_app/src/common/model/feed_content_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedContentHeader extends StatelessWidget {
  const FeedContentHeader({super.key, required this.feedContent});

  final FeedContent feedContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SmallTag(text: feedContent.categoryName),
                    const SizedBox(width: 4),
                    SmallTag(
                      text: '주 ${feedContent.certCnt}회',
                      backgroundColor: AppColors.systemGrey4,
                      foregroundColor: AppColors.systemGrey1,
                    ),
                  ],
                ),
                Text(
                  feedContent.title,
                  overflow: TextOverflow.ellipsis,
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.push('/challenge/${feedContent.roomId}');
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
