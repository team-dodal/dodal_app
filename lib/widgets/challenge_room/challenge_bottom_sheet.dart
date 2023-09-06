import 'dart:io';

import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/bookmark_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeBottomSheet extends StatefulWidget {
  const ChallengeBottomSheet({
    super.key,
    this.onPress,
    required this.buttonText,
    required this.bookmarked,
    required this.roomId,
  });

  final void Function()? onPress;
  final bool bookmarked;
  final String buttonText;
  final int roomId;

  @override
  State<ChallengeBottomSheet> createState() => _ChallengeBottomSheetState();
}

class _ChallengeBottomSheetState extends State<ChallengeBottomSheet> {
  late bool _bookmarkStatus;

  _handleBookmark() async {
    if (mounted) {
      showBookmarkSnackBar(
          context, '북마크가 ${_bookmarkStatus ? '해제' : '추가'}되었어요.');
      setState(() {
        _bookmarkStatus = !_bookmarkStatus;
      });
    }
    final res = await ChallengeService.bookmark(
      roomId: widget.roomId,
      value: _bookmarkStatus,
    );
    if (res == null) {
      setState(() {
        _bookmarkStatus = !_bookmarkStatus;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _bookmarkStatus = widget.bookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    String iconPath = _bookmarkStatus
        ? 'assets/icons/bookmark_active_icon.svg'
        : 'assets/icons/bookmark_icon.svg';
    Color iconColor =
        _bookmarkStatus ? AppColors.orange : AppColors.systemGrey2;
    Color iconButtonBackgroundColor =
        _bookmarkStatus ? AppColors.lightOrange : AppColors.systemWhite;
    Color iconButtonBorderColor =
        _bookmarkStatus ? AppColors.orange : AppColors.systemGrey3;

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
                  onPressed: _handleBookmark,
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
  }
}
