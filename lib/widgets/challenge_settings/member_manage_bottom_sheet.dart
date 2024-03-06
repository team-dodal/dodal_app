import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/providers/manage_challenge_member_bloc.dart';
import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/repositories/manage_challenge_repository.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberManageBottomSheet extends StatelessWidget {
  const MemberManageBottomSheet({
    super.key,
    required this.userId,
    required this.roomId,
  });

  final int userId;
  final int roomId;

  handOverAdmin(BuildContext context) async {
    final res = await ManageChallengeRepository.handOverAdmin(
      roomId: roomId,
      userId: userId,
    );
    if (context.mounted) {
      Navigator.pop(context);

      if (res) {
        showDialog(
          context: context,
          builder: (context) => const SystemDialog(
            subTitle: '방장 권한을 성공적으로 넘겼습니다',
          ),
        );
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      }
    }
  }

  banishUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        subTitle: '해당 유저를 내보낼까요?',
        children: [
          SystemDialogButton(
            text: '취소',
            onPressed: () {
              Navigator.pop(context);
            },
            primary: false,
          ),
          SystemDialogButton(
            text: '내보내기',
            onPressed: () async {
              Navigator.pop(context);
              final res = await ManageChallengeRepository.banishUser(
                roomId: roomId,
                userId: userId,
              );
              if (res == null || !res) return;
              if (!context.mounted) return;
              context
                  .read<ManageChallengeMemberBloc>()
                  .add(LoadManageChallengeMemberEvent());
              showDialog(
                context: context,
                builder: (context) => const SystemDialog(
                  subTitle: '유저를 내보냈습니다.',
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text('내보내기', style: context.body2())),
            onTap: () {
              banishUser(context);
            },
          ),
          ListTile(
            title: Center(child: Text('신고하기', style: context.body2())),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(roomId: roomId),
                ),
              );
            },
          ),
          ListTile(
            title: Center(child: Text('방장 권한 넘기기', style: context.body2())),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SystemDialog(
                  subTitle: '방장 권한을 넘기시겠습니까?',
                  children: [
                    SystemDialogButton(
                      text: '취소',
                      primary: false,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SystemDialogButton(
                      text: '확인',
                      onPressed: () async {
                        await handOverAdmin(context);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
