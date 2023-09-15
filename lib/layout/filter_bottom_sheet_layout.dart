import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

class FilterBottomSheetLayout extends StatelessWidget {
  const FilterBottomSheetLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.bgColor1,
        ),
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
