import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({
    super.key,
    this.onChanged,
    this.title = '',
    this.required = false,
    this.placeholder = '',
    required this.controller,
    this.child,
    this.textInputAction = TextInputAction.done,
    required this.maxNumber,
  });

  final TextEditingController controller;
  final bool required;
  final String? title;
  final void Function(int)? onChanged;
  final String placeholder;
  final Widget? child;
  final TextInputAction textInputAction;
  final int maxNumber;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  void _onTextFieldFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    _focusNode.addListener(_onTextFieldFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onTextFieldFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text(
                widget.title!,
                style: Typo(context)
                    .body1()!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              if (widget.required)
                Text(
                  '*',
                  style: Typo(context)
                      .body1()!
                      .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                )
            ]),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              _isFocused
                  ? const BoxShadow(
                      color: AppColors.systemGrey3,
                      offset: Offset(0, 0),
                      blurRadius: 8,
                      blurStyle: BlurStyle.outer,
                    )
                  : const BoxShadow()
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              fillColor:
                  _isFocused ? AppColors.systemWhite : AppColors.bgColor3,
              counterText: '',
              hintText: widget.placeholder,
            ),
            style:
                Typo(context).body2()!.copyWith(fontWeight: FontWeight.normal),
            onChanged: (value) {
              if (widget.onChanged == null) return;
              widget.onChanged!(int.parse(value));
            },
            textInputAction: widget.textInputAction,
            onSubmitted: (value) =>
                widget.textInputAction == TextInputAction.next
                    ? FocusScope.of(context).nextFocus()
                    : null,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              NumericRangeFormatter(min: 0, max: widget.maxNumber),
            ],
          ),
        ),
      ],
    );
  }
}

class NumericRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newValueNumber = double.tryParse(newValue.text);

    if (newValueNumber == null) {
      return oldValue;
    }

    if (newValueNumber < min) {
      return newValue.copyWith(text: min.toString());
    } else if (newValueNumber > max) {
      return newValue.copyWith(text: max.toString());
    } else {
      return newValue;
    }
  }
}
