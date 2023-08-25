import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
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
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
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
        InputTitle(
          title: widget.title!,
          required: widget.required,
          wordLength: widget.wordLength,
          isFocused: _isFocused,
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
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: widget.child,
              ),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
            style: context.body2(fontWeight: FontWeight.normal),
            onChanged: (value) {
              if (widget.onChanged == null) return;
              widget.onChanged!(value);
            },
            textInputAction: widget.textInputAction,
            onSubmitted: (value) =>
                widget.textInputAction == TextInputAction.next
                    ? FocusScope.of(context).nextFocus()
                    : null,
            minLines: widget.multiLine ? 3 : 1,
            maxLines: widget.multiLine ? 10 : 1,
            maxLength: widget.maxLength,
          ),
        ),
      ],
    );
  }
}
