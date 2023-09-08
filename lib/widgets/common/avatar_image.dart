import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/image_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarImage extends StatefulWidget {
  const AvatarImage({
    super.key,
    this.onChanged,
    required this.image,
    required this.width,
    required this.height,
  });

  final Function? onChanged;
  final dynamic image;
  final double width, height;

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
        setImage: (image) {
          widget.onChanged!(image);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChanged != null ? _showBottomSheet : null,
      child: Stack(
        children: [
          ImageWidget(
            image: widget.image,
            width: widget.width,
            height: widget.height,
            shape: BoxShape.circle,
          ),
          if (widget.onChanged != null)
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
                ),
              ),
            )
        ],
      ),
    );
  }
}
