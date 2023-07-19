import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreeButton extends StatelessWidget {
  const AgreeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/check_icon.svg',
                    height: 4,
                    width: 4,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '[필수] 제공동의 내용내용내용내용내용',
                  style: Typo(context).body3()!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.systemGrey1,
                      ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              '보기',
              style: Typo(context).body3()!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.systemGrey2,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: AppColors.systemGrey2,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
