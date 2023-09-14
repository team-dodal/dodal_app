import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankListItem extends StatelessWidget {
  const RankListItem({
    super.key,
    required this.rank,
    required this.profileUrl,
    required this.nickname,
    required this.certCnt,
    required this.userId,
  });

  final int rank;
  final int userId;
  final String? profileUrl;
  final String nickname;
  final int certCnt;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, User?>(builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: state!.id == userId
              ? AppColors.lightYellow
              : AppColors.systemWhite,
          border: const Border(
            top: BorderSide(color: AppColors.systemGrey4),
            bottom: BorderSide(color: AppColors.systemGrey4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$rank',
                  style: context.body2(color: AppColors.systemGrey2),
                ),
                const SizedBox(width: 16),
                ImageWidget(
                  image: profileUrl,
                  width: 40,
                  height: 40,
                  shape: BoxShape.circle,
                ),
                const SizedBox(width: 9),
                Text(nickname, style: context.body2()),
              ],
            ),
            Text(
              '인증 $certCnt회',
              style: context.body4(color: AppColors.systemGrey1),
            ),
          ],
        ),
      );
    });
  }
}
