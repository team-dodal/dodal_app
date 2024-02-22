import 'package:dodal_app/providers/challenge_info_bloc.dart';
import 'package:dodal_app/providers/create_feed_bloc.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:dodal_app/widgets/common/input/text_input.dart';
import 'package:dodal_app/widgets/create_feed/feed_bottom_sheet.dart';
import 'package:dodal_app/widgets/create_feed/feed_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFeedScreen extends StatefulWidget {
  const CreateFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<CreateFeedScreen> createState() => _CreateFeedScreenState();
}

class _CreateFeedScreenState extends State<CreateFeedScreen> {
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

  _successAlert() {
    showDialog(
      context: context,
      builder: (ctx) => SystemDialog(
        subTitle: '피드가 성공적으로 업로드되었습니다.',
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ChallengeInfoBloc(widget.challenge.id),
                    child: const ChallengeRoute(),
                  ),
                ),
                (route) => route.isFirst,
              );
            },
            child: const Text('확인'),
          )
        ],
      ),
    );
  }

  _errorAlert(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => SystemDialog(subTitle: errorMessage),
    );
    Navigator.pop(context);
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
              Navigator.pop(context);
            },
          ),
          SystemDialogButton(
            text: '업로드하기',
            onPressed: () {
              context
                  .read<CreateFeedBloc>()
                  .add(SubmitCreateFeedEvent(widget.challenge.id, frameKey));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  bool _buttonDisabled() {
    if (context.read<CreateFeedBloc>().state.image == null) return true;
    if (context.read<CreateFeedBloc>().state.content.isEmpty) return true;
    if (context.read<CreateFeedBloc>().state.status ==
        CreateFeedStatus.loading) {
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
        if (state.status == CreateFeedStatus.success) {
          _successAlert();
        }
        if (state.status == CreateFeedStatus.error) {
          _errorAlert(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.challenge.title)),
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
            child: state.status == CreateFeedStatus.loading
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
