import 'dart:io';
import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
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
      File compressedImage = await imageCompress(File(pickedImage.path));
      if (!mounted) return;
      widget.setImage(compressedImage);
    } catch (err) {
      showDialog(
          context: context,
          builder: (ctx) => const SystemDialog(subTitle: '이 이미지는 사용할 수 없습니다'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: Column(
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
    );
  }
}
