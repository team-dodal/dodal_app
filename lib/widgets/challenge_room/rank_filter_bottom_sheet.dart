import 'dart:io';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

enum ChallengeRankFilterEnum { all, month, week }

String challengeRankFilterEnumText(ChallengeRankFilterEnum value) {
  if (value == ChallengeRankFilterEnum.all) {
    return '전체';
  } else if (value == ChallengeRankFilterEnum.month) {
    return '월간';
  } else if (value == ChallengeRankFilterEnum.week) {
    return '주간';
  } else {
    return '';
  }
}

class RankFilterBottomSheet extends StatelessWidget {
  const RankFilterBottomSheet({super.key, required this.onChange});

  final void Function(ChallengeRankFilterEnum value) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.bgColor1,
        ),
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Column(
              children: ChallengeRankFilterEnum.values
                  .map(
                    (item) => ListTile(
                      title: Text(
                        challengeRankFilterEnumText(item),
                        style: context.body2(),
                      ),
                      onTap: () {
                        onChange(item);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
