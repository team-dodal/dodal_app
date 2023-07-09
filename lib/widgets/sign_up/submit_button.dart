import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPress,
  });

  final void Function()? onPress;

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
            padding: const EdgeInsets.only(bottom: 20),
          ),
          child: Text(
            '다음',
            style: Typo(context).body1()!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.systemGrey5,
                ),
          ),
        ),
      ),
    );
  }
}
