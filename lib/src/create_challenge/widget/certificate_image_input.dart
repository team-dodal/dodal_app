import 'dart:io';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/image_bottom_sheet.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:flutter/material.dart';

enum CertOption { correct, wrong }

class CertificateImageInput extends StatelessWidget {
  const CertificateImageInput({
    super.key,
    required this.image,
    this.onChange,
    required this.certOption,
  });

  final dynamic image;
  final void Function(File?)? onChange;
  final CertOption certOption;

  _showBottomSheet(BuildContext context) {
    if (onChange == null) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
        imageDefaultOption: false,
        setImage: (image) {
          onChange!(image);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(context);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Builder(
                builder: (context) {
                  if (image != null && image != null) {
                    return ImageWidget(
                      image: image,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 26,
                          color: AppColors.systemGrey2,
                        ),
                        Text(
                          '인증 예시 넣기',
                          style: context.body4(color: AppColors.systemGrey2),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                color: certOption == CertOption.correct
                    ? AppColors.success
                    : AppColors.danger,
                width: double.infinity,
                height: 28,
                child: Text(
                  certOption == CertOption.correct ? '성공' : '실패',
                  style: context.body4(
                    fontWeight: FontWeight.bold,
                    color: AppColors.systemWhite,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
