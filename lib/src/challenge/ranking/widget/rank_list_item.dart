import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: context.read<UserBloc>().state.result!.id == userId
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
  }
}
