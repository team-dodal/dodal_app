import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class SystemDialog extends StatelessWidget {
  const SystemDialog({
    super.key,
    this.title,
    required this.subTitle,
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
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: AppColors.bgColor1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  title ?? '알림',
                  style: Typo(context)
                      .headline4()!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (subTitle!.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(subTitle!, style: Typo(context).body4()),
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
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('확인'),
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
