import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

class CrossDivider extends StatelessWidget {
  const CrossDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8,
      decoration: const BoxDecoration(color: AppColors.systemGrey4),
    );
  }
}
