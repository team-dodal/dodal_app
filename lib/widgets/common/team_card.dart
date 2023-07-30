import 'package:dodal_app/screens/group_route/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return const GroupRoute();
        }));
      },
      child: SizedBox(
        height: 88,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Row(
                        children: [
                          SmallTag(text: '홈 트레이닝'),
                          SizedBox(width: 4),
                          SmallTag(
                            text: '인증횟수',
                            foregroundColor: AppColors.systemGrey1,
                            backgroundColor: AppColors.systemGrey4,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          padding: const EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                            'assets/icons/bookmark_icon.svg',
                            width: 12,
                            height: 17,
                            colorFilter: const ColorFilter.mode(
                              AppColors.systemGrey2,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '[주 3일] 체중 -8kg 뽀개기 / 식단 관리',
                    style: Typo(context)
                        .body3()!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const AvatarImage(
                      image: '',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'asdasd · ',
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
                      '12/20',
                      style: Typo(context)
                          .body4()!
                          .copyWith(color: AppColors.systemGrey1),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
