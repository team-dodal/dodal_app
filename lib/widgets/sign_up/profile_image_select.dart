import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileImageSelect extends StatefulWidget {
  const ProfileImageSelect({
    super.key,
    required this.onChanged,
    required this.image,
  });

  final Function onChanged;
  final dynamic image;

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
                if (widget.image != null && widget.image != '') {
                  return FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: widget.image is File
                        ? FileImage(widget.image)
                        : NetworkImage(widget.image) as ImageProvider,
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
                  color: AppColors.bgColor1,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.systemGrey2,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/camera_icon.svg',
                  width: 12,
                  fit: BoxFit.scaleDown,
                  colorFilter: const ColorFilter.mode(
                    AppColors.orange,
                    BlendMode.srcIn,
                  ),
                )
                //  const Icon(
                //   Icons.camera_alt_outlined,
                //   color: Colors.white,
                //   size: 18,
                // ),
                ),
          )
        ],
      ),
    );
  }
}
