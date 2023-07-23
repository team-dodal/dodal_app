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
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
          ),
          child: Text(
            title,
            style: Typo(context).body1()!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.systemWhite,
                ),
          ),
        ),
      ),
    );
  }
}
