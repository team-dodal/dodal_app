import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
  });

  final String text;
  final void Function()? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        !disabled ? AppColors.systemWhite : AppColors.systemGrey4;
    Color foregroundColor =
        !disabled ? AppColors.systemGrey2 : AppColors.systemGrey2;
    Color borderColor =
        !disabled ? AppColors.systemGrey3 : AppColors.systemGrey4;

    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                text,
                style: context.body1(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
            )),
      ),
    );
  }
}
