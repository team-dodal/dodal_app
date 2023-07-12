import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import '../../theme/typo.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    this.onChanged,
    this.title = '',
    this.wordLength,
    this.required = false,
    this.multiLine = false,
    this.placeholder = '',
    required this.maxLength,
    required this.controller,
    this.child,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final bool required;
  final String? title;
  final String? wordLength;
  final void Function(String)? onChanged;
  final bool multiLine;
  final int maxLength;
  final String placeholder;
  final Widget? child;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text(
                title!,
                style: Typo(context)
                    .body1()!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              if (required)
                Text(
                  '*',
                  style: Typo(context)
                      .body1()!
                      .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                )
            ]),
            if (wordLength != null)
              Text(
                wordLength!,
                style: Typo(context)
                    .body2()!
                    .copyWith(color: AppColors.systemGrey2),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  fillColor: AppColors.bgColor2,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  counterText: '',
                  hintText: placeholder,
                  hintStyle: Typo(context).body2()!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: AppColors.systemGrey2,
                      ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: child,
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
                style: Typo(context)
                    .body2()!
                    .copyWith(fontWeight: FontWeight.normal),
                onChanged: (value) {
                  if (onChanged == null) return;
                  onChanged!(value);
                },
                textInputAction: textInputAction,
                onSubmitted: (value) => textInputAction == TextInputAction.next
                    ? FocusScope.of(context).nextFocus()
                    : null,
                minLines: multiLine ? 3 : 1,
                maxLines: multiLine ? 10 : 1,
                maxLength: maxLength,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
