import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBottomSheet extends StatefulWidget {
  const ImageBottomSheet({super.key, required this.setImage});

  final Function setImage;

  @override
  State<ImageBottomSheet> createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<ImageBottomSheet> {
  void _pickImage(ImageSource type) async {
    final imagePicker = ImagePicker();
    late XFile? pickedImage;

    try {
      pickedImage = await imagePicker.pickImage(source: type);
      if (pickedImage == null) return;
      widget.setImage(File(pickedImage.path));
    } catch (err) {
      showDialog(
          context: context,
          builder: (ctx) => const SystemDialog(title: '이 이미지는 사용할 수 없습니다'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.bgColor1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('직접 촬영'),
              onTap: () {
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              title: const Text('엘범에서 사진 선택'),
              onTap: () {
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
