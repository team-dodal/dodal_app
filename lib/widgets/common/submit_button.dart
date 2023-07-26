import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPress,
    required this.title,
  });

  final void Function()? onPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(top: 20, bottom: Platform.isIOS ? 40 : 20),
          ),
          child: Text(
            title,
            style: Typo(context).body1()!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onPress != null
                      ? AppColors.systemWhite
                      : AppColors.systemGrey2,
                ),
          ),
        ),
      ),
    );
  }
}
