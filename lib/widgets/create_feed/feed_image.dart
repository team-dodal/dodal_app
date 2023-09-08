import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedImage extends StatefulWidget {
  const FeedImage({super.key, required this.image});

  final File? image;

  @override
  State<FeedImage> createState() => _FeedImageState();
}

class _FeedImageState extends State<FeedImage> {
  bool _isWhiteText = true;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.systemGrey4),
        child: Builder(
          builder: (context) {
            if (widget.image != null) {
              return Stack(
                children: [
                  ImageWidget(
                    image: widget.image,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isWhiteText = !_isWhiteText;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd').format(now),
                            style: context.headline4(
                              color: _isWhiteText
                                  ? AppColors.systemWhite
                                  : AppColors.systemBlack,
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(now),
                            style: context.headline(
                              color: _isWhiteText
                                  ? AppColors.systemWhite
                                  : AppColors.systemBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 50,
                    color: AppColors.systemGrey2,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
