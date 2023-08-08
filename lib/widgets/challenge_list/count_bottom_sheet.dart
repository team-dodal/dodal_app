import 'dart:io';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CountBottomSheet extends StatelessWidget {
  const CountBottomSheet({
    super.key,
    required this.cubit,
    required this.onChanged,
  });

  final ChallengeListFilter cubit;
  final void Function(int) onChanged;

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
            Text(
              '도전 빈도 선택',
              style:
                  Typo(context).body1()!.copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 120,
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 82 / 46,
                  children: [
                    const CountButton(text: '전체'),
                    for (final i in [1, 2, 3, 4, 5, 6])
                      CountButton(text: '주 $i회'),
                    const CountButton(text: '매일')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountButton extends StatelessWidget {
  const CountButton({
    super.key,
    required this.text,
    this.onPressed,
    this.selected = false,
  });

  final String text;
  final bool selected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 82,
        height: 46,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor:
                selected ? AppColors.systemGrey1 : AppColors.systemGrey4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          child: Text(
            text,
            style: Typo(context).body2()!.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    selected ? AppColors.systemWhite : AppColors.systemBlack),
          ),
        ),
      ),
    );
  }
}
