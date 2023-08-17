import 'dart:io';
import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RoomThumbnailImage extends StatelessWidget {
  const RoomThumbnailImage({
    super.key,
    required this.image,
  });

  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(color: AppColors.systemGrey4),
      child: Builder(
        builder: (context) {
          if (image != null) {
            if (image is File) {
              return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: FileImage(image),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            } else {
              return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(image),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
