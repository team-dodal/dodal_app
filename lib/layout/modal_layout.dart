import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

class ModalLayout extends StatelessWidget {
  const ModalLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.bgColor1,
        ),
        child: child,
      ),
    );
  }
}
