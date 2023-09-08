import 'dart:io';
import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 0,
  });

  final dynamic image;
  final double width;
  final double height;
  final BoxShape shape;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.systemGrey4,
        shape: shape,
        borderRadius: borderRadius != 0
            ? BorderRadius.all(Radius.circular(borderRadius))
            : null,
      ),
      child: Builder(
        builder: (context) {
          if (image != null) {
            if (image is File) {
              return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: FileImage(image),
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            } else {
              return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(image),
                alignment: Alignment.topCenter,
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
