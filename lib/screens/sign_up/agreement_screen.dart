import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/sign_up/agree_button.dart';
import 'package:dodal_app/widgets/sign_up/all_agree_button.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:flutter/material.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps;
  final int step;
  final void Function() nextStep;

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  List<bool> _agreements = [false, false, false, false];

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
                  _agreements = [true, true, true, true];
                });
              },
            ),
            const SizedBox(height: 24),
            AgreeButton(
              context: '[필수] 제공동의 내용내용내용내용내용',
              value: _agreements[0],
              onChanged: (value) {
                _onChanged(0, value);
              },
              morePress: () {},
            ),
            const SizedBox(height: 16),
            AgreeButton(
              context: '[필수] 제공동의 내용내용내용내용내용',
              value: _agreements[1],
              onChanged: (value) {
                _onChanged(1, value);
              },
              morePress: () {},
            ),
            const SizedBox(height: 16),
            AgreeButton(
              context: '[선택] 제공동의 내용내용내용내용내용',
              value: _agreements[2],
              onChanged: (value) {
                _onChanged(2, value);
              },
              morePress: () {},
            ),
            const SizedBox(height: 16),
            AgreeButton(
              context: '[선택] 제공동의 내용내용내용내용내용',
              value: _agreements[3],
              onChanged: (value) {
                _onChanged(3, value);
              },
              morePress: () {},
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
