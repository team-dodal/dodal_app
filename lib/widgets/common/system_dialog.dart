import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class SystemDialog extends StatelessWidget {
  const SystemDialog({
    super.key,
    this.title,
    this.subTitle,
    this.children,
  });

  final String? title;
  final String? subTitle;
  final List<Widget>? children;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  title ?? '알림',
                  style: context.body1(fontWeight: FontWeight.bold),
                  softWrap: false,
                ),
                Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      subTitle ?? '',
                      style: context.body4(color: AppColors.systemGrey1),
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Builder(builder: (context) {
              if (children == null) {
                return Row(
                  children: [
                    Expanded(
                      child: SystemDialogButton(
                        text: '확인',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                );
              } else {
                return Row(
                  children: [
                    for (int i = 0; i < children!.length; i++)
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: children![i]),
                            if (i != children!.length - 1)
                              const SizedBox(width: 6),
                          ],
                        ),
                      ),
                  ],
                );
              }
            })
          ],
        ),
      ),
    );
  }
}

class SystemDialogButton extends StatelessWidget {
  const SystemDialogButton({
    super.key,
    required this.text,
    this.primary = true,
    required this.onPressed,
  });

  final String text;
  final bool primary;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        child: Text(
          text,
          style: context.body2(color: AppColors.systemWhite),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.systemWhite,
          padding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: AppColors.systemGrey3),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        child: Text(
          text,
          style: context.body2(color: AppColors.systemBlack),
        ),
      );
    }
  }
}
