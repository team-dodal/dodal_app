import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:flutter/material.dart';

class ChallengeContentScreen extends StatefulWidget {
  const ChallengeContentScreen({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps, step;
  final void Function() nextStep;

  @override
  State<ChallengeContentScreen> createState() => _ChallengeContentScreenState();
}

class _ChallengeContentScreenState extends State<ChallengeContentScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            children: [],
          ),
        ),
      ),
      bottomSheet: SubmitButton(onPress: widget.nextStep, title: '다음'),
    );
  }
}
