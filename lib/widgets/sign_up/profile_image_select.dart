import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ProfileImageSelect extends StatefulWidget {
  const ProfileImageSelect(
      {super.key, required this.onChanged, required this.image});

  final Function onChanged;
  final File? image;

  @override
  State<ProfileImageSelect> createState() => _ProfileImageSelectState();
}

class _ProfileImageSelectState extends State<ProfileImageSelect> {
  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
        setImage: (image) {
          widget.onChanged(image);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheet,
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.systemGrey4,
              shape: BoxShape.circle,
            ),
            child: Builder(
              builder: (context) {
                if (widget.image != null) {
                  return Image.file(
                    widget.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: AppColors.systemGrey2,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
