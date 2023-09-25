import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';

class GridChallengeBox extends StatelessWidget {
  const GridChallengeBox({super.key, required this.challenge});

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.systemGrey3,
            offset: Offset(0, 0),
            blurRadius: 8,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 1,
            child: ImageWidget(
              image: challenge.thumbnailImg,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 4,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SmallTag(text: challenge.tag.name),
                    const SizedBox(width: 4),
                    SmallTag(
                      text: '주 ${challenge.certCnt}회',
                      backgroundColor: AppColors.systemGrey4,
                      foregroundColor: AppColors.systemGrey1,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.title,
                  style: context.body2(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    AvatarImage(
                      image: challenge.adminProfile,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      challenge.adminNickname,
                      style: context.body4(color: AppColors.systemGrey1),
                    ),
                    Text(
                      ' · ',
                      style: context.body4(color: AppColors.systemGrey1),
                    ),
                    const Icon(
                      Icons.person,
                      color: AppColors.systemGrey2,
                      size: 20,
                    ),
                    Text(
                      '${challenge.userCnt}/${challenge.recruitCnt}',
                      style: context.body4(color: AppColors.systemGrey1),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
