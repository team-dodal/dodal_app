import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CreateFormTitle extends StatelessWidget {
  const CreateFormTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.currentStep,
    this.steps,
  });

  final String title;
  final String? subTitle;
  final int? currentStep;
  final int? steps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (steps != null || currentStep != null)
            Column(
              children: [
                Row(
                  children: [
                    for (var step = 1; step <= steps!; step++)
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: step == currentStep
                                  ? AppColors.systemBlack
                                  : AppColors.systemGrey4,
                            ),
                            child: Center(
                              child: Text(
                                '$step',
                                style: Typo(context).body4()!.copyWith(
                                      color: step == currentStep
                                          ? AppColors.systemWhite
                                          : AppColors.systemGrey2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          if (step != steps)
                            Container(
                              height: 1,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.systemGrey3,
                              ),
                            )
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
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