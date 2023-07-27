import 'dart:io';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

enum CertOption { correct, wrong }

class CertificateImageInput extends StatelessWidget {
  const CertificateImageInput({
    super.key,
    required this.image,
    this.onChange,
    required this.certOption,
  });

  final File? image;
  final void Function(File?)? onChange;
  final CertOption certOption;

  _showBottomSheet(BuildContext context) {
    if (onChange == null) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
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
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(color: AppColors.systemGrey4),
                child: Builder(
                  builder: (context) {
                    if (image != null) {
                      return FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    }
                    return const SizedBox();
                  },
                ),
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
                  style: Typo(context).body4()!.copyWith(
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
