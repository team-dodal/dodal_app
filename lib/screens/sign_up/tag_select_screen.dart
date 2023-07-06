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
    widget.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('${widget.step} / 2'),
            ],
          ),
        ),
        Positioned(
          child: ElevatedButton(
            style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size.infinite)),
            onPressed: _handleNextStep,
            child: const Text('다음'),
          ),
        ),
      ],
    );
  }
}
