import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ChallengeBox extends StatefulWidget {
  const ChallengeBox({
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
  State<ChallengeBox> createState() => _ChallengeBoxState();
}

class _ChallengeBoxState extends State<ChallengeBox> {
  late bool _bookmarkStatus;

  _handleBookmark() async {
    await ChallengeService.bookmark(
      roomId: widget.id,
      value: !_bookmarkStatus,
    );
    setState(() {
      _bookmarkStatus = !_bookmarkStatus;
    });
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
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.systemGrey4,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Builder(
                builder: (context) {
                  if (widget.thumbnailImg != null) {
                    return FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(widget.thumbnailImg!),
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
                          isSelected: _bookmarkStatus,
                          selectedIcon: const Icon(
                            Icons.bookmark_rounded,
                            color: AppColors.systemBlack,
                          ),
                          icon: const Icon(
                            Icons.bookmark_border_rounded,
                            color: AppColors.systemGrey1,
                          ),
                          iconSize: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.title,
                  style: Typo(context)
                      .body2()!
                      .copyWith(fontWeight: FontWeight.bold),
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
                    style: Typo(context)
                        .body4()!
                        .copyWith(color: AppColors.systemGrey1),
                  ),
                  const Icon(
                    Icons.person,
                    color: AppColors.systemGrey2,
                    size: 20,
                  ),
                  Text(
                    '${widget.userCnt}/${widget.recruitCnt}',
                    style: Typo(context)
                        .body4()!
                        .copyWith(color: AppColors.systemGrey1),
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
