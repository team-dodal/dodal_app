import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ChallengeBox extends StatelessWidget {
  const ChallengeBox({
    super.key,
    required this.title,
    required this.thumbnailImg,
    required this.tag,
    required this.adminProfile,
    required this.adminNickname,
    required this.recruitCnt,
    required this.userCnt,
    required this.certCnt,
  });

  final String title;
  final String? thumbnailImg;
  final Tag tag;
  final String? adminProfile;
  final String adminNickname;
  final int certCnt;
  final int recruitCnt;
  final int userCnt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.systemGrey4,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Builder(
                builder: (context) {
                  if (thumbnailImg != null) {
                    return FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(thumbnailImg!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SmallTag(text: tag.name),
                  const SizedBox(width: 4),
                  SmallTag(
                    text: '주 $certCnt회',
                    backgroundColor: AppColors.systemGrey4,
                    foregroundColor: AppColors.systemGrey1,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Typo(context)
                    .body2()!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(children: [
                AvatarImage(
                  image: adminProfile,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '$adminNickname · ',
                  style: Typo(context)
                      .body4()!
                      .copyWith(color: AppColors.systemGrey1),
                ),
                const Icon(
                  Icons.person,
                  color: AppColors.systemGrey2,
                  size: 20,
                ),
                Text(
                  '$userCnt/$recruitCnt',
                  style: Typo(context)
                      .body4()!
                      .copyWith(color: AppColors.systemGrey1),
                ),
              ]),
            ],
          )
        ],
      ),
    );
  }
}
