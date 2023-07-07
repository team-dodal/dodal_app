import 'package:flutter/material.dart';

import '../../theme/typo.dart';

class SystemDialog extends StatelessWidget {
  const SystemDialog({
    super.key,
    required this.title,
    this.subTitle = '',
    required this.children,
  });

  final String title;
  final String? subTitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  title,
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
            Row(
              children: [
                for (int i = 0; i < children.length; i++)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: children[i]),
                        if (i != children.length - 1) const SizedBox(width: 6),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
