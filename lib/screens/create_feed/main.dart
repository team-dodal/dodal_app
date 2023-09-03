import 'dart:io';

import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:dodal_app/widgets/create_feed/feed_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CreateFeedScreen extends StatefulWidget {
  const CreateFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<CreateFeedScreen> createState() => _CreateFeedScreenState();
}

class _CreateFeedScreenState extends State<CreateFeedScreen> {
  TextEditingController contentController = TextEditingController();
  File? _image;

  _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _showBottomSheet(BuildContext context) {
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
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        title: '인증 게시물을 업로드 하시겠어요?',
        subTitle: '업로드 후에 삭제는 가능하지만, 수정은 불가능합니다.',
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.systemWhite,
              padding: const EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: AppColors.systemGrey3),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: Text(
              '취소',
              style: context.body2(color: AppColors.systemBlack),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: Text(
              '업로드하기',
              style: context.body2(color: AppColors.systemWhite),
            ),
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
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showBottomSheet(context);
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    decoration:
                        const BoxDecoration(color: AppColors.systemGrey4),
                    child: Builder(
                      builder: (context) {
                        if (_image != null) {
                          return FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        } else {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 50,
                                color: AppColors.systemGrey2,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
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
      bottomSheet: FeedBottomSheet(
        onPress: _image == null || contentController.text.isEmpty
            ? null
            : _createFeed,
      ),
    );
  }
}
