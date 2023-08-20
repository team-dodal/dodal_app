import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'avatar_image.dart';

class RoomInfoBox extends StatelessWidget {
  const RoomInfoBox({
    super.key,
    required this.title,
    required this.tagName,
    required this.adminProfile,
    required this.adminNickname,
    required this.maxMember,
    required this.curMember,
    required this.certCnt,
  });

  final String title, tagName, adminNickname;
  final String? adminProfile;
  final int maxMember, curMember, certCnt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SmallTag(text: tagName),
            const SizedBox(width: 4),
            SmallTag(
              text: '주 $certCnt회',
              foregroundColor: AppColors.systemGrey1,
              backgroundColor: AppColors.systemGrey4,
            ),
          ]),
          const SizedBox(height: 12),
          Text(
            title,
            style: Typo(context)
                .headline2()!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(children: [
            AvatarImage(
              image: adminProfile,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 6),
            Text(
              '$adminNickname · ',
              style:
                  Typo(context).body4()!.copyWith(color: AppColors.systemGrey1),
            ),
            const Icon(
              Icons.person,
              color: AppColors.systemGrey2,
              size: 20,
            ),
            Text(
              '멤버 $curMember',
              style:
                  Typo(context).body4()!.copyWith(color: AppColors.systemBlack),
            ),
            Text(
              '/$maxMember',
              style:
                  Typo(context).body4()!.copyWith(color: AppColors.systemGrey2),
            ),
          ]),
        ],
      ),
    );
  }
}
