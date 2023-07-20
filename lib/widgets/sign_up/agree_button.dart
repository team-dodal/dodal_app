import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreeButton extends StatelessWidget {
  const AgreeButton({
    super.key,
    required this.onChanged,
    required this.value,
    required this.context,
    required this.morePress,
  });

  final void Function(bool?) onChanged;
  final void Function() morePress;
  final String context;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Material(
                child: InkWell(
                  onTap: () {
                    onChanged(!value);
                  },
                  borderRadius: BorderRadius.circular(26),
                  child: Ink(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: value ? AppColors.yellow : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.5,
                        color: value ? AppColors.yellow : AppColors.systemGrey3,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.5),
                      child: SvgPicture.asset(
                        'assets/icons/check_icon.svg',
                        colorFilter: ColorFilter.mode(
                          value ? AppColors.systemBlack : AppColors.systemGrey3,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                child: InkWell(
                  onTap: () {
                    onChanged(!value);
                  },
                  child: Ink(
                    child: Text(
                      '[필수] 제공동의 내용내용내용내용내용',
                      style: Typo(context).body3()!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.systemGrey1,
                          ),
                    ),
                  ),
                ),
              ),
            ],
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
