import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class ThumbnailImageInput extends StatelessWidget {
  const ThumbnailImageInput({
    super.key,
    this.image,
    required this.onChange,
  });

  final File? image;
  final Function onChange;

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
        setImage: (image) {
          onChange(image);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle(title: '도전 썸네일', subTitle: '도전을 대표할 사진을 선택해주세요.'),
        const SizedBox(height: 10),
        GestureDetector(
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
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 184,
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.systemBlack.withOpacity(0.3),
                    width: double.infinity,
                    height: 28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/camera_icon.svg',
                          fit: BoxFit.scaleDown,
                          colorFilter: const ColorFilter.mode(
                            AppColors.systemWhite,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '사진 선택',
                          style: Typo(context).body4()!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.systemWhite,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('* 사진 미선택시 기본 썸네일로 설정됩니다.',
            style: Typo(context).caption()!.copyWith(
                  color: AppColors.systemGrey1,
                )),
      ],
    );
  }
}
