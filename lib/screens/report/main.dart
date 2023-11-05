import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/input/text_input.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';

enum ReportItem {
  value_1('상업적/홍보성'),
  value_2('저작권침해'),
  value_3('음란성/선정성'),
  value_4('욕설/인신공격'),
  value_5('불법정보'),
  value_6('개인정보노출'),
  value_7('기타');

  const ReportItem(this.title);
  final String title;
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportItem? _reportValue;
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('신고하기')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '이 게시물을 신고하시겠어요?',
            style: context.headline4(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '신고 사유에 해당하는지 검토 후 처리됩니다.',
            style: context.body4(color: AppColors.systemGrey1),
          ),
          const SizedBox(height: 24),
          for (final reportItem in ReportItem.values)
            RadioListTile(
              title: Text(reportItem.title),
              contentPadding: const EdgeInsets.all(0),
              value: reportItem,
              groupValue: _reportValue,
              onChanged: (value) {
                setState(() {
                  _reportValue = value;
                });
              },
            ),
          if (_reportValue == ReportItem.value_7)
            TextInput(
              maxLength: 500,
              controller: textEditingController,
              placeholder: '신고 사유를 입력해 주세요.',
              multiLine: true,
            )
        ],
      ),
      bottomSheet: SubmitButton(
          onPress: _reportValue != null
              ? () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => const SystemDialog(
                      title: '신고가 완료되었습니다.',
                    ),
                  );
                }
              : null,
          title: '신고하기'),
    );
  }
}
