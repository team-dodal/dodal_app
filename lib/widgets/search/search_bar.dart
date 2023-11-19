import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final Function(String) onSubmit;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          textAlignVertical: TextAlignVertical.bottom,
          onChanged: (_) {
            setState(() {});
          },
          onSubmitted: widget.onSubmit,
          decoration: InputDecoration(
            hintText: '검색어를 입력하세요',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100),
            ),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100),
            ),
            suffixIcon: widget.controller.text == ''
                ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                : IconButton(
                    onPressed: () {
                      widget.controller.text = '';
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
      ),
    );
  }
}
