import 'package:dodal_app/src/challenge/challenge_settings_menu/bloc/challenge_join_cubit.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MemberMenu extends StatelessWidget {
  const MemberMenu({super.key, required this.challenge});

  final ChallengeDetail challenge;

  challengeOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => SystemDialog(
        title: '정말로 나가시겠습니까?',
        subTitle: '만약 이 그룹의 관리자라면, 권한을 다른 사람에게 넘겨야 합니다.',
        children: [
          SystemDialogButton(
            text: '취소',
            primary: false,
            onPressed: context.pop,
          ),
          SystemDialogButton(
            text: '나가기',
            onPressed: () {
              context.read<ChallengeJoinCubit>().out();
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void _error(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(subTitle: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChallengeJoinCubit, ChallengeJoinState>(
      listener: (context, state) {
        if (state.status == CommonStatus.error) {
          _error(context, state.errorMessage!);
        }
        if (state.status == CommonStatus.loaded) {
          context.go('/main');
        }
      },
      child: Column(
        children: [
          ListTile(
            title: Text('나가기', style: context.body3(color: AppColors.danger)),
            onTap: () {
              challengeOut(context);
            },
          ),
          ListTile(
            title: Text('신고하기', style: context.body3(color: AppColors.danger)),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.danger,
            ),
            onTap: () {
              context.push('/report/${challenge.id}');
            },
          ),
        ],
      ),
    );
  }
}
