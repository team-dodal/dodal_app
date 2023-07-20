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
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: value ? AppColors.yellow : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: value ? AppColors.yellow : AppColors.systemGrey2,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/check_icon.svg',
                    colorFilter: ColorFilter.mode(
                      value ? AppColors.systemBlack : AppColors.systemGrey2,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.none,
                  ),
                ),
                const SizedBox(width: 6),
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

    // OutlinedButton(
    //   onPressed: onPressed,
    //   style: OutlinedButton.styleFrom(
    //     minimumSize: const Size(double.infinity, 72),
    //     backgroundColor: value ? AppColors.bgColor1 : AppColors.systemGrey4,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //     ),
    //     side: BorderSide(
    // color: value ? AppColors.systemBlack : AppColors.systemGrey4,
    // width: 1,
    //     ),
    //   ),
    //   child:
    // );
  }
}
