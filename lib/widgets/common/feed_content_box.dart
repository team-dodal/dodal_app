import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedContentBox extends StatelessWidget {
  const FeedContentBox({super.key, required this.feedContent});

  final FeedContentResponse feedContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FeedContentHeader(feedContent: feedContent),
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ImageWidget(
                  image: feedContent.certImgUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.systemWhite,
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.systemGrey3,
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: Text(
                    '🔥 ${feedContent.continueCertCnt}회째 실천 중!',
                    style: context.caption(
                      fontWeight: FontWeight.bold,
                      color: AppColors.systemGrey1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          FeedContentFooter(feedContent: feedContent),
        ],
      ),
    );
  }
}

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
                '제목제목',
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

class FeedContentFooter extends StatelessWidget {
  const FeedContentFooter({super.key, required this.feedContent});

  final FeedContentResponse feedContent;

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
                  const AvatarImage(image: null, width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(
                    feedContent.nickname,
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
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
