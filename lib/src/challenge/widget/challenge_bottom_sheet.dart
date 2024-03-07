import 'dart:io';

import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeBottomSheet extends StatefulWidget {
  const ChallengeBottomSheet({
    super.key,
    this.onPress,
    required this.buttonText,
  });

  final void Function()? onPress;
  final String buttonText;

  @override
  State<ChallengeBottomSheet> createState() => _ChallengeBottomSheetState();
}

class _ChallengeBottomSheetState extends State<ChallengeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        String iconPath = state.isBookmarked
            ? 'assets/icons/bookmark_active_icon.svg'
            : 'assets/icons/bookmark_icon.svg';
        Color iconColor =
            state.isBookmarked ? AppColors.orange : AppColors.systemGrey2;
        Color iconButtonBackgroundColor =
            state.isBookmarked ? AppColors.lightOrange : AppColors.systemWhite;
        Color iconButtonBorderColor =
            state.isBookmarked ? AppColors.orange : AppColors.systemGrey3;

        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.systemWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.systemGrey3,
                  offset: Offset(0, 0),
                  blurRadius: 8,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8 + (Platform.isIOS ? 20 : 0),
                left: 8,
                right: 8,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: IconButton(
                      onPressed: () {
                        context.read<BookmarkBloc>().add(ChangeBookmarkEvent());
                      },
                      icon: SvgPicture.asset(
                        iconPath,
                        width: 25,
                        height: 25,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      style: IconButton.styleFrom(
                        side: BorderSide(color: iconButtonBorderColor),
                        backgroundColor: iconButtonBackgroundColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onPress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        widget.buttonText,
                        style: context.body1(
                          fontWeight: FontWeight.bold,
                          color: widget.onPress != null
                              ? AppColors.systemWhite
                              : AppColors.systemGrey2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
