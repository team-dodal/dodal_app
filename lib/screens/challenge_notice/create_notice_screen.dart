import 'package:dodal_app/services/challenge/service.dart';
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
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 작성하기'),
        actions: [
          TextButton(
            onPressed: titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty
                ? _createNotice
                : null,
            child: const Text('완료'),
          )
        ],
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextInput(
                  controller: titleController,
                  title: '공지 제목',
                  placeholder: '공지사항의 제목을 입력해 주세요.',
                  wordLength: '${titleController.text.length}/40',
                  maxLength: 40,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 40),
                TextInput(
                  controller: contentController,
                  title: '공지 내용',
                  placeholder: '멤버들에게 공지할 내용을 작성해 주세요.',
                  wordLength: '${contentController.text.length}/500',
                  maxLength: 500,
                  multiLine: true,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
