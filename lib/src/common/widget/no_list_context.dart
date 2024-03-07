import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoListContext extends StatelessWidget {
  const NoListContext({
    super.key,
    required this.title,
    this.subTitle,
    this.buttonText,
    this.onButtonPress,
  });

  final String title;
  final String? subTitle;
  final String? buttonText;
  final Function? onButtonPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/flag_icon.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.systemGrey2,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: context.body1(fontWeight: FontWeight.bold),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: context.body4(color: AppColors.systemGrey2),
          ),
        const SizedBox(height: 16),
        if (onButtonPress != null && buttonText != null)
          TextButton(
            onPressed: () {
              onButtonPress!();
            },
            style: TextButton.styleFrom(
              side: const BorderSide(color: AppColors.systemGrey3),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: AppColors.systemWhite,
            ),
            child: Text(
              buttonText!,
              style: context.body4(color: AppColors.systemGrey1),
            ),
          ),
      ],
    );
  }
}
