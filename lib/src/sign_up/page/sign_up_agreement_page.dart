import 'package:dodal_app/src/common/widget/create_form_title.dart';
import 'package:dodal_app/src/sign_up/widget/agree_button.dart';
import 'package:dodal_app/src/sign_up/widget/all_agree_button.dart';
import 'package:dodal_app/src/common/widget/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpAgreementPage extends StatefulWidget {
  const SignUpAgreementPage({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps;
  final int step;
  final void Function() nextStep;

  @override
  State<SignUpAgreementPage> createState() => _SignUpAgreementPageState();
}

class _SignUpAgreementPageState extends State<SignUpAgreementPage> {
  List<bool> _agreements = [false, false];

  _onChanged(int idx, bool? value) {
    List<bool> copy = [..._agreements];
    if (value == null) return;
    copy[idx] = value;
    setState(() {
      _agreements = copy;
    });
  }

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
            AllAgreeButton(
              value: _agreements.every((agree) => agree == true),
              onPressed: () {
                setState(() {
                  _agreements = [true, true];
                });
              },
            ),
            const SizedBox(height: 24),
            AgreeButton(
              text: '[필수] 이용약관 동의',
              value: _agreements[0],
              onChanged: (value) {
                _onChanged(0, value);
              },
              morePress: () {
                context.push('/settings/service-rule');
              },
            ),
            const SizedBox(height: 16),
            AgreeButton(
              text: '[필수] 개인정보 취급 동의',
              value: _agreements[1],
              onChanged: (value) {
                _onChanged(1, value);
              },
              morePress: () {
                context.push('/settings/personal-data-rule');
              },
            ),
          ],
        ),
      ),
      bottomSheet: SubmitButton(
        onPress:
            _agreements[0] && _agreements[1] == true ? widget.nextStep : null,
        title: '다음',
      ),
    );
  }
}
