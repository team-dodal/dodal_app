import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class SearchItemButton extends StatelessWidget {
  const SearchItemButton({
    super.key,
    required this.text,
    this.onTap,
    this.onCloseTap,
  });

  final String text;
  final Function()? onTap;
  final Function()? onCloseTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.systemGrey3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: context.body4(color: AppColors.systemGrey1),
              ),
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: onCloseTap,
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.systemGrey2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
