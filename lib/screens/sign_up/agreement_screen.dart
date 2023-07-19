import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/sign_up/agree_button.dart';
import 'package:dodal_app/widgets/sign_up/submit_button.dart';
import 'package:flutter/material.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({
    super.key,
    required this.steps,
    required this.step,
  });

  final int steps;
  final int step;

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            CreateFormTitle(
              title: '원활한 도달 서비스\n사용을 위해\n약관에 동의해주세요.',
              steps: widget.steps,
              currentStep: widget.step,
            ),
            const SizedBox(height: 50),
            const AgreeButton(),
            const SizedBox(height: 16),
            const AgreeButton(),
            const SizedBox(height: 16),
            const AgreeButton(),
            const SizedBox(height: 16),
            const AgreeButton(),
          ],
        ),
      ),
      bottomSheet: SubmitButton(onPress: () {}, title: '다음'),
    );
  }
}
