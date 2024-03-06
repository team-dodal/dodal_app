import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/providers/bookmark_bloc.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/bookmark_snack_bar.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridChallengeBox extends StatelessWidget {
  const GridChallengeBox({super.key, required this.challenge});
  final Challenge challenge;

  void success(BuildContext context, BookmarkState state) {
    showBookmarkSnackBar(
      context,
      '북마크가 ${state.isBookmarked ? '추가' : '해제'}되었어요.',
    );
  }

  void error(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(subTitle: errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkBloc, BookmarkState>(
      listener: (context, state) {
        if (state.status == CommonStatus.loaded) {
          success(context, state);
        }
        if (state.status == CommonStatus.error) {
          error(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
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
                      image: challenge.thumbnailImg,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 4,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context
                              .read<BookmarkBloc>()
                              .add(ChangeBookmarkEvent());
                        },
                        icon: SvgPicture.asset(
                          state.isBookmarked
                              ? 'assets/icons/bookmark_active_icon.svg'
                              : 'assets/icons/bookmark_icon.svg',
                          // width: 25,
                          // height: 25,
                          colorFilter: ColorFilter.mode(
                            state.isBookmarked
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
                      SmallTag(text: challenge.tag.name),
                      const SizedBox(width: 4),
                      SmallTag(
                        text: '주 ${challenge.certCnt}회',
                        backgroundColor: AppColors.systemGrey4,
                        foregroundColor: AppColors.systemGrey1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    challenge.title,
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
                        image: challenge.adminProfile,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          challenge.adminNickname,
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
                        '${challenge.userCnt}/${challenge.recruitCnt}',
                        style: context.caption(color: AppColors.systemGrey1),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
