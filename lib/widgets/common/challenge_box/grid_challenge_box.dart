import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/bookmark_snack_bar.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridChallengeBox extends StatefulWidget {
  const GridChallengeBox({super.key, required this.challenge});

  final Challenge challenge;

  @override
  State<GridChallengeBox> createState() => _GridChallengeBoxState();
}

class _GridChallengeBoxState extends State<GridChallengeBox> {
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
      roomId: widget.challenge.id,
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
      _bookmarkStatus = widget.challenge.isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                ImageWidget(
                  image: widget.challenge.thumbnailImg,
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 4,
                ),
                Positioned(
                  top: 0,
                  right: 0,
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
                            : AppColors.systemGrey2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SmallTag(text: widget.challenge.tag.name),
                  const SizedBox(width: 4),
                  SmallTag(
                    text: '주 ${widget.challenge.certCnt}회',
                    backgroundColor: AppColors.systemGrey4,
                    foregroundColor: AppColors.systemGrey1,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.challenge.title,
                style: context.body2(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  AvatarImage(
                    image: widget.challenge.adminProfile,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      widget.challenge.adminNickname,
                      style: context.caption(color: AppColors.systemGrey1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    ' · ',
                    style: context.caption(color: AppColors.systemGrey1),
                  ),
                  const Icon(
                    Icons.person,
                    color: AppColors.systemGrey2,
                    size: 16,
                  ),
                  Text(
                    '${widget.challenge.userCnt}/${widget.challenge.recruitCnt}',
                    style: context.caption(color: AppColors.systemGrey1),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
