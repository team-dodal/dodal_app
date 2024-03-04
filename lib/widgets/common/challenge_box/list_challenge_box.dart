import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/model/tag_model.dart';
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
import 'package:shimmer/shimmer.dart';

class ListChallengeBox extends StatefulWidget {
  const ListChallengeBox({
    super.key,
    required this.title,
    required this.thumbnailImg,
    required this.tag,
    required this.adminProfile,
    required this.adminNickname,
    required this.recruitCnt,
    required this.userCnt,
    required this.certCnt,
  });

  final String title;
  final String? thumbnailImg;
  final Tag tag;
  final String? adminProfile;
  final String adminNickname;
  final int certCnt;
  final int recruitCnt;
  final int userCnt;

  @override
  State<ListChallengeBox> createState() => _ListChallengeBoxState();
}

class _ListChallengeBoxState extends State<ListChallengeBox> {
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
          color: AppColors.systemWhite,
          height: 100,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                            SizedBox(
                              width: 30,
                              height: 30,
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
                                        : AppColors.systemGrey1,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.title,
                          maxLines: 2,
                          style: context.body2(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(mainAxisSize: MainAxisSize.max, children: [
                      AvatarImage(
                        image: widget.adminProfile,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          widget.adminNickname,
                          overflow: TextOverflow.ellipsis,
                          style: context.body4(color: AppColors.systemGrey1),
                        ),
                      ),
                      Text(
                        ' · ',
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
      },
    );
  }
}

class ListChallengeBoxSkeleton extends StatelessWidget {
  const ListChallengeBoxSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.systemWhite,
      height: 100,
      child: Shimmer.fromColors(
        baseColor: AppColors.systemGrey4,
        highlightColor: AppColors.systemWhite,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: AppColors.systemGrey4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 20,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: AppColors.systemGrey4,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 40,
                                height: 20,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: AppColors.systemGrey4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 18,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: AppColors.systemGrey4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity - 100,
                        height: 18,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: AppColors.systemGrey4,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.systemGrey4,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 80,
                        height: 20,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: AppColors.systemGrey4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
