import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/report_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedContentFooter extends StatelessWidget {
  const FeedContentFooter({super.key, required this.feedContent});

  final FeedContentResponse feedContent;

  @override
  Widget build(BuildContext context) {
    _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const ReportBottomSheet();
        },
      );
    }

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
                  const AvatarImage(image: null, width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(
                    feedContent.nickname,
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
          Text(feedContent.certContent),
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
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border_rounded),
                      ),
                      Text(
                        '${feedContent.likeCnt}',
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
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/chat_icon.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.systemGrey1,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        '${feedContent.accuseCnt}',
                        style: context.body2(color: AppColors.systemGrey1),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${DateTime.now().difference(feedContent.registeredAt).inHours}시간 전',
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
