import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/create_challenge_notice_bloc.dart';
import 'package:dodal_app/widgets/common/input/text_input.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _error() {
    showDialog(
      context: context,
      builder: (context) {
        return const SystemDialog(
          subTitle: '공지사항을 작성하는 중에 오류가 발생했습니다.',
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateChallengeNoticeBloc, CreateChallengeNoticeState>(
      listener: (context, state) {
        if (state.status == CommonStatus.error) {
          _error();
        }
        if (state.status == CommonStatus.loaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('글 작성하기'),
            actions: [
              TextButton(
                onPressed: state.title.isNotEmpty && state.content.isNotEmpty
                    ? () {
                        context
                            .read<CreateChallengeNoticeBloc>()
                            .add(CreateEvent());
                      }
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
                        context
                            .read<CreateChallengeNoticeBloc>()
                            .add(ChangeTitleEvent(value));
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
                        context
                            .read<CreateChallengeNoticeBloc>()
                            .add(ChangeContentEvent(value));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
