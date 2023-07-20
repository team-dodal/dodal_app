import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllAgreeButton extends StatelessWidget {
  const AllAgreeButton({
    super.key,
    required this.value,
    required this.onPressed,
  });

  final bool value;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: value ? AppColors.bgColor1 : AppColors.systemGrey4,
          boxShadow: [
            value
                ? const BoxShadow(
                    color: AppColors.systemGrey3,
                    offset: Offset(0, 0),
                    blurRadius: 8,
                    blurStyle: BlurStyle.outer,
                  )
                : const BoxShadow()
          ],
          border: Border.all(
            color: value ? AppColors.systemBlack : AppColors.systemGrey4,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Ink(
            child: Row(
              children: [
                Container(
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
                const SizedBox(width: 9),
                Text(
                  '모두 동의해요',
                  style: Typo(context).body1()!.copyWith(
                        color: value
                            ? AppColors.systemBlack
                            : AppColors.systemGrey2,
                        fontWeight: FontWeight.bold,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
