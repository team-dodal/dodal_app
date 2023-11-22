import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

class BottomTextInput extends StatelessWidget {
  const BottomTextInput(
      {super.key, required this.controller, required this.postComment});

  final TextEditingController controller;
  final Future<void> Function() postComment;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(8, 8, 8, Platform.isIOS ? 24 : 8),
        decoration: BoxDecoration(
          color: AppColors.systemWhite,
          border: Border.all(color: AppColors.systemGrey4),
        ),
        child: Row(
          children: [
            Flexible(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.systemGrey4,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: '댓글을 작성해 주세요.',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: postComment,
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.systemWhite,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.systemGrey2,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
