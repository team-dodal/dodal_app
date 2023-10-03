import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';

class FeedContentHeader extends StatelessWidget {
  const FeedContentHeader({super.key, required this.feedContent});

  final FeedContentResponse feedContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                style: context.body1(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
