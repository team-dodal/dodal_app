import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:flutter/material.dart';

class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({super.key, required this.roomId});

  final int roomId;

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _createNotice() async {
    await ChallengeService.createNotice(
      roomId: widget.roomId,
      title: titleController.text,
      content: contentController.text,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextInput(
                  controller: titleController,
                  title: '제목',
                  placeholder: '제목을 입력해주세요.',
                  required: true,
                  wordLength: '${titleController.text.length}/16',
                  maxLength: 16,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 40),
                TextInput(
                  controller: contentController,
                  title: '본문',
                  placeholder: '본문을 입력해주세요.',
                  required: true,
                  wordLength: '${contentController.text.length}/50',
                  maxLength: 50,
                  multiLine: true,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SubmitButton(
          onPress: titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty
              ? _createNotice
              : null,
          title: '생성'),
    );
  }
}
