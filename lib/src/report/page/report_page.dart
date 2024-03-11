import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/repositories/firestore_repository.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/input/text_input.dart';
import 'package:dodal_app/src/common/widget/submit_button.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, this.roomId, this.userId});

  final int? roomId;
  final int? userId;
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ReportItem? _reportValue;
  TextEditingController textEditingController = TextEditingController();

  void _report() async {
    final res = await FireStoreRepository.reportUser(
      userId: context.read<AuthBloc>().state.user!.id,
      userName: context.read<AuthBloc>().state.user!.nickname,
      reason: _reportValue!.title,
      detailReason: textEditingController.text,
      targetRoomId: widget.roomId,
      targetUserId: widget.userId,
    );
    if (res) {
      context.pop();
      showDialog(
        context: context,
        builder: (context) => const SystemDialog(subTitle: '신고가 완료되었습니다.'),
      );
    }
  }

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
                _report();
              }
            : null,
        title: '신고하기',
      ),
    );
  }
}
