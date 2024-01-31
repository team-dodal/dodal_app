import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

class FeedBottomSheet extends StatelessWidget {
  const FeedBottomSheet({
    super.key,
    required this.onPress,
    required this.child,
  });

  final void Function()? onPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      return const SizedBox();
    }

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.systemWhite,
          border: Border(
            top: BorderSide(color: AppColors.basicColor1),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 8 + (Platform.isIOS ? 20 : 0),
            left: 8,
            right: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPress,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
