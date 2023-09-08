import 'dart:io';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class FeedBottomSheet extends StatefulWidget {
  const FeedBottomSheet({
    super.key,
    required this.onPress,
  });

  final void Function()? onPress;

  @override
  State<FeedBottomSheet> createState() => _FeedBottomSheetState();
}

class _FeedBottomSheetState extends State<FeedBottomSheet> {
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
                  onPressed: widget.onPress,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    '인증하기',
                    style: context.body1(
                      fontWeight: FontWeight.bold,
                      color: widget.onPress != null
                          ? AppColors.systemWhite
                          : AppColors.systemGrey2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
