import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import '../../theme/typo.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    this.validator,
    this.onChanged,
    this.title = '',
    this.onPressed,
    this.buttonText = '',
    this.wordLength,
    this.required = false,
    this.multiLine = false,
    this.placeholder = '',
    required this.maxLength,
    required this.controller,
  });

  final TextEditingController controller;
  final bool required;
  final String? title;
  final String? wordLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onPressed;
  final String? buttonText;
  final bool multiLine;
  final int maxLength;
  final String placeholder;

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
              child: TextFormField(
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
                  suffixIcon: Builder(builder: (context) {
                    if (onPressed == null) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.transparent),
                          backgroundColor: AppColors.systemGrey5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                        onPressed: onPressed,
                        child: Text(
                          buttonText!,
                          style: Typo(context).body3()!.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    );
                  }),
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
                validator: validator,
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
