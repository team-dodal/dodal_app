import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class SmallTag extends StatelessWidget {
  const SmallTag({
    super.key,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String text;
  final Color? backgroundColor, foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightOrange,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        text,
        style: Typo(context).caption()!.copyWith(
              color: foregroundColor ?? AppColors.orange,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
