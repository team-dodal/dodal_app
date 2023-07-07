import 'package:flutter/material.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({
    super.key,
    required this.step,
    required this.nextStep,
  });

  final int step;
  final Function nextStep;

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  _handleNextStep() async {
    widget.nextStep({
      "category": ["001001", "002003", "004001"]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: const SingleChildScrollView(
        child: Column(),
      ),
      bottomSheet: SafeArea(
        child: SizedBox(
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _handleNextStep,
            child: const Text('다음'),
          ),
        ),
      ),
    );
  }
}
