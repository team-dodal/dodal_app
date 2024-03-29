import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/create_feed/bloc/create_feed_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/image_bottom_sheet.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:dodal_app/src/common/widget/input/text_input.dart';
import 'package:dodal_app/src/create_feed/widget/feed_bottom_sheet.dart';
import 'package:dodal_app/src/create_feed/widget/feed_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateFeedPage extends StatefulWidget {
  const CreateFeedPage({super.key, required this.title});

  final String title;

  @override
  State<CreateFeedPage> createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  TextEditingController contentController = TextEditingController();
  GlobalKey frameKey = GlobalKey();

  _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _showBottomSheet() {
    _dismissKeyboard();
    showModalBottomSheet(
      context: context,
      builder: (_) => ImageBottomSheet(
        setImage: (image) {
          context.read<CreateFeedBloc>().add(ChangeImageCreateFeedEvent(image));
        },
      ),
    );
  }

  _successAlert() async {
    await showDialog(
      context: context,
      builder: (ctx) => SystemDialog(
        subTitle: '피드가 성공적으로 업로드되었습니다.',
        children: [
          ElevatedButton(
            onPressed: context.pop,
            child: const Text('확인'),
          )
        ],
      ),
    );
    context.pop(true);
  }

  _errorAlert(String errorMessage) async {
    await showDialog(
      context: context,
      builder: (ctx) => SystemDialog(subTitle: errorMessage),
    );
    context.pop();
  }

  _handleSubmit() async {
    showDialog(
      context: context,
      builder: (_) => SystemDialog(
        title: '인증 게시물을 업로드 하시겠어요?',
        subTitle: '업로드 후에 삭제는 가능하지만, 수정은 불가능합니다.',
        children: [
          SystemDialogButton(
            text: '취소',
            primary: false,
            onPressed: () {
              context.pop();
            },
          ),
          SystemDialogButton(
            text: '업로드하기',
            onPressed: () {
              context
                  .read<CreateFeedBloc>()
                  .add(SubmitCreateFeedEvent(frameKey));
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  bool _buttonDisabled() {
    if (context.read<CreateFeedBloc>().state.image == null) return true;
    if (context.read<CreateFeedBloc>().state.status == CommonStatus.loading) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateFeedBloc, CreateFeedState>(
      listener: (context, state) {
        if (state.status == CommonStatus.loaded) {
          _successAlert();
        }
        if (state.status == CommonStatus.error) {
          _errorAlert(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: GestureDetector(
            onTap: _dismissKeyboard,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showBottomSheet,
                      child: RepaintBoundary(
                        key: frameKey,
                        child: FeedImage(image: state.image),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInput(
                        controller: contentController,
                        placeholder: '오늘의 인증에 대해 입력해주세요.',
                        maxLength: 100,
                        multiLine: true,
                        onChanged: (value) {
                          context
                              .read<CreateFeedBloc>()
                              .add(ChangeContentCreateFeedEvent(value));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: FeedBottomSheet(
            onPress: _buttonDisabled() ? null : _handleSubmit,
            child: state.status == CommonStatus.loading
                ? const CupertinoActivityIndicator()
                : Text(
                    '인증하기',
                    style: context.body1(
                      fontWeight: FontWeight.bold,
                      color: _buttonDisabled()
                          ? AppColors.systemGrey2
                          : AppColors.systemWhite,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
