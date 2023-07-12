import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CreateFormTitle extends StatelessWidget {
  const CreateFormTitle({
    super.key,
    required this.title,
    this.subTitle,
    required this.currentStep,
    required this.steps,
  });

  final String title;
  final String? subTitle;
  final int currentStep;
  final int steps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$currentStep',
                style: Typo(context)
                    .body1()!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '/$steps',
                style: Typo(context).body1()!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: currentStep == steps
                          ? AppColors.systemBlack
                          : AppColors.systemGrey2,
                    ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Typo(context)
                .headline2()!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          if (subTitle != null)
            Text(
              subTitle!,
              style:
                  Typo(context).body4()!.copyWith(color: AppColors.systemGrey1),
            ),
        ],
      ),
    );
  }
}
