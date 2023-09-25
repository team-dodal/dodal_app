import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/bookmark_snack_bar.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListChallengeBox extends StatefulWidget {
  const ListChallengeBox({
    super.key,
    required this.id,
    required this.title,
    required this.thumbnailImg,
    required this.tag,
    required this.adminProfile,
    required this.adminNickname,
    required this.recruitCnt,
    required this.userCnt,
    required this.certCnt,
    this.isBookmarked,
  });

  final int id;
  final String title;
  final String? thumbnailImg;
  final Tag tag;
  final String? adminProfile;
  final String adminNickname;
  final int certCnt;
  final int recruitCnt;
  final int userCnt;
  final bool? isBookmarked;

  @override
  State<ListChallengeBox> createState() => _ListChallengeBoxState();
}

class _ListChallengeBoxState extends State<ListChallengeBox> {
  late bool _bookmarkStatus;

  _handleBookmark() async {
    if (mounted) {
      showBookmarkSnackBar(
        context,
        '북마크가 ${_bookmarkStatus ? '해제' : '추가'}되었어요.',
      );
      setState(() {
        _bookmarkStatus = !_bookmarkStatus;
      });
    }
    final res = await ChallengeService.bookmark(
      roomId: widget.id,
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
      if (widget.isBookmarked != null) {
        _bookmarkStatus = widget.isBookmarked!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.systemWhite,
      height: 90,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ImageWidget(
              image: widget.thumbnailImg,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 4,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SmallTag(text: widget.tag.name),
                        const SizedBox(width: 4),
                        SmallTag(
                          text: '주 ${widget.certCnt}회',
                          backgroundColor: AppColors.systemGrey4,
                          foregroundColor: AppColors.systemGrey1,
                        ),
                      ],
                    ),
                    if (widget.isBookmarked != null)
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _handleBookmark,
                          icon: SvgPicture.asset(
                            _bookmarkStatus
                                ? 'assets/icons/bookmark_active_icon.svg'
                                : 'assets/icons/bookmark_icon.svg',
                            // width: 25,
                            // height: 25,
                            colorFilter: ColorFilter.mode(
                              _bookmarkStatus
                                  ? AppColors.systemBlack
                                  : AppColors.systemGrey1,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.title,
                  style: context.body2(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  AvatarImage(
                    image: widget.adminProfile,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.adminNickname} · ',
                    style: context.body4(color: AppColors.systemGrey1),
                  ),
                  const Icon(
                    Icons.person,
                    color: AppColors.systemGrey2,
                    size: 20,
                  ),
                  Text(
                    '${widget.userCnt}/${widget.recruitCnt}',
                    style: context.body4(color: AppColors.systemGrey1),
                  ),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}