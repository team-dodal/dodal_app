import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class InputTitle extends StatelessWidget {
  const InputTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.required,
    this.wordLength,
    this.isFocused = false,
  });

  final String title;
  final String? subTitle;
  final String? wordLength;
  final bool? required;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: Typo(context)
                      .body1()!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (required == true)
                  Text(
                    '*',
                    style: Typo(context).body1()!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )
              ],
            ),
            if (wordLength != null)
              Text(
                wordLength!,
                style: Typo(context).body2()!.copyWith(
                      color: isFocused
                          ? AppColors.systemBlack
                          : AppColors.systemGrey2,
                    ),
              ),
          ],
        ),
        if (subTitle != null) Text(subTitle!, style: Typo(context).body4()),
      ],
    );
  }
}
