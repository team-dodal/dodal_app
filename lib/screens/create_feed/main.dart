import 'dart:io';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/utilities/add_watermark.dart';
import 'package:dodal_app/utilities/image_compress.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:dodal_app/widgets/common/input/text_input.dart';
import 'package:dodal_app/widgets/create_feed/feed_bottom_sheet.dart';
import 'package:dodal_app/widgets/create_feed/feed_image.dart';
import 'package:flutter/material.dart';

class CreateFeedScreen extends StatefulWidget {
  const CreateFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<CreateFeedScreen> createState() => _CreateFeedScreenState();
}

class _CreateFeedScreenState extends State<CreateFeedScreen> {
  TextEditingController contentController = TextEditingController();
  GlobalKey frameKey = GlobalKey();
  File? _image;

  _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _showBottomSheet(BuildContext context) {
    _dismissKeyboard();
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
        setImage: (image) {
          setState(() {
            _image = image;
          });
        },
      ),
    );
  }

  _createFeed() async {
    final file = await captureCreateImage(frameKey);
    if (file == null) return;
    final compressedFile = await imageCompress(file);

    if (!mounted) return;
    Navigator.pop(context);

    final res = await ChallengeService.createFeed(
      challengeId: widget.challenge.id,
      content: contentController.text,
      image: compressedFile,
    );
    if (!mounted) return;
    if (!res) return;

    showDialog(
      context: context,
      builder: (ctx) => const SystemDialog(subTitle: '피드가 성공적으로 업로드되었습니다.'),
    );
    Navigator.pop(context);
  }

  _handleSubmit() async {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
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
            onPressed: () async {
              await _createFeed();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: RepaintBoundary(
                    key: frameKey,
                    child: FeedImage(image: _image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInput(
                    controller: contentController,
                    placeholder: '오늘의 인증에 대해 입력해주세요.',
                    maxLength: 100,
                    multiLine: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: FeedBottomSheet(
        onPress: _image == null || contentController.text.isEmpty
            ? null
            : _handleSubmit,
      ),
    );
  }
}
