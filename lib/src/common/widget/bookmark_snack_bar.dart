import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';

showBookmarkSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: AppColors.systemGrey1,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.systemGrey3,
                offset: Offset(0, 0),
                blurRadius: 20,
                blurStyle: BlurStyle.outer,
              ),
            ]),
        child: Center(
          child: Text(
            text,
            style: context.body2(color: AppColors.systemWhite),
          ),
        ),
      ),
      duration: const Duration(seconds: 1),
    ),
  );
}
