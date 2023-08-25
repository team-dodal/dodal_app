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
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
                if (required == true)
                  Text(
                    '*',
                    style: context.body1(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )
              ],
            ),
            if (wordLength != null)
              Text(
                wordLength!,
                style: context.body2(
                  color:
                      isFocused ? AppColors.systemBlack : AppColors.systemGrey2,
                ),
              ),
          ],
        ),
        if (subTitle != null) Text(subTitle!, style: context.body4()),
      ],
    );
  }
}
