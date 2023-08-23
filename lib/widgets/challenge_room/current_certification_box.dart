import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';

class CurrentCertificationBox extends StatelessWidget {
  const CurrentCertificationBox({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '내 인증 현황',
                style: Typo(context)
                    .body1()!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              const Text('+23일 째 도전중!'),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GridView.count(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final i in [1, 2, 3, 4, 5, 6, 7])
                  DayCircle(
                    dayNum: i,
                    isToday: i == currentDayOfWeek,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DayCircle extends StatelessWidget {
  const DayCircle({super.key, required this.dayNum, required this.isToday});

  final int dayNum;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];
    return Stack(
      children: [
        const AvatarImage(
            image: null, width: double.infinity, height: double.infinity),
        Positioned(
          bottom: 0,
          right: 0,
          child: isToday
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.systemGrey3,
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: Text('Today', style: Typo(context).caption()),
                )
              : Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.systemWhite,
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.systemGrey3,
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(daysOfWeek[dayNum - 1],
                        style: Typo(context).caption()),
                  ),
                ),
        )
      ],
    );
  }
}
