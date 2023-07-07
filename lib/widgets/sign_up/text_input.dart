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
    required this.maxLength,
  });

  final bool required;
  final String? title;
  final String? wordLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onPressed;
  final String? buttonText;
  final bool multiLine;
  final int maxLength;

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
                      .copyWith(fontWeight: FontWeight.bold),
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
        Container(
          padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
          decoration: const BoxDecoration(
            color: AppColors.bgColor2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: onChanged,
                  validator: validator,
                  minLines: multiLine ? 3 : 1,
                  maxLines: multiLine ? 10 : 1,
                  maxLength: maxLength,
                ),
              ),
              if (onPressed != null)
                ElevatedButton(
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(buttonText!),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
