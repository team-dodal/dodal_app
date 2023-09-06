import 'dart:io';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/utilities/image_compress.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBottomSheet extends StatefulWidget {
  const ImageBottomSheet({
    super.key,
    required this.setImage,
    this.imageDefaultOption = true,
  });

  final Function setImage;
  final bool imageDefaultOption;

  @override
  State<ImageBottomSheet> createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<ImageBottomSheet> {
  void _pickImage(ImageSource? type) async {
    final imagePicker = ImagePicker();
    late XFile? pickedImage;

    if (type == null) {
      widget.setImage(null);
      Navigator.pop(context);
      return;
    }

    try {
      pickedImage = await imagePicker.pickImage(source: type);
      if (pickedImage == null) return;
      final compressedImage = await testCompressAndGetFile(pickedImage);
      if (!mounted) return;
      widget.setImage(File(compressedImage.path));
    } catch (err) {
      print(err);
      showDialog(
          context: context,
          builder: (ctx) => const SystemDialog(subTitle: '이 이미지는 사용할 수 없습니다'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.bgColor1,
        ),
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: Text('직접 촬영', style: context.body2()),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  title: Text('엘범에서 사진 선택', style: context.body2()),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (widget.imageDefaultOption)
                  ListTile(
                    title: Text('기본 이미지로 변경', style: context.body2()),
                    onTap: () {
                      _pickImage(null);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
