import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_settings/member_manage_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';

class MemberCertificationBox extends StatelessWidget {
  const MemberCertificationBox({super.key});

  _showCountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const MemberManageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AvatarImage(image: null, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Woody',
                        style: context.body4(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '인증 4회 | 인증 실패 1회',
                        style: context.caption(color: AppColors.systemGrey1),
                      ),
                    ],
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  _showCountBottomSheet(context);
                },
                child: Text(
                  '관리하기',
                  style: context.caption(
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 17),
          SizedBox(
            height: 50,
            child: GridView.count(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final i in [1, 2, 3, 4, 5, 6, 7]) const FeedImageBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FeedImageBox extends StatelessWidget {
  const FeedImageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.systemGrey3,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
