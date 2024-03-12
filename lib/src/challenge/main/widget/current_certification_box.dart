import 'package:dodal_app/src/common/enum/day_enum.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/avatar_image.dart';
import 'package:flutter/material.dart';

class CurrentCertificationBox extends StatelessWidget {
  const CurrentCertificationBox({
    super.key,
    required this.userWeekList,
    required this.continueCertCnt,
  });

  final int continueCertCnt;
  final List<UserCertPerWeek> userWeekList;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '내 인증 현황',
                style: context.body1(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              Text('+$continueCertCnt일 째 도전중!'),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GridView.count(
              crossAxisCount: DayEnum.values.length,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final day in DayEnum.values)
                  Builder(
                    builder: (context) {
                      final contains = userWeekList
                          .where((element) => element.dayCode == day)
                          .toList();
                      final content = contains.isNotEmpty ? contains[0] : null;

                      return DayCircle(
                        dayNum: day,
                        isToday: day == DayEnum.values[now.weekday - 1],
                        content: content,
                      );
                    },
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
  const DayCircle({
    super.key,
    required this.dayNum,
    required this.isToday,
    required this.content,
  });

  final DayEnum dayNum;
  final bool isToday;
  final UserCertPerWeek? content;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AvatarImage(
          image: content?.certImageUrl,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isToday ? AppColors.yellow : AppColors.systemWhite,
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.systemGrey3,
                  offset: Offset(0, 0),
                  blurRadius: 8,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Center(
              child: Text(dayNum.name, style: context.caption()),
            ),
          ),
        )
      ],
    );
  }
}
