import 'package:dodal_app/src/common/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/src/challenge/manage/bloc/manage_challenge_member_bloc.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MemberManageBottomSheet extends StatelessWidget {
  const MemberManageBottomSheet({super.key, required this.userId});

  final int userId;

  void assignmentUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => SystemDialog(
        subTitle: '방장 권한을 넘기시겠습니까?',
        children: [
          SystemDialogButton(
            text: '취소',
            primary: false,
            onPressed: context.pop,
          ),
          SystemDialogButton(
            text: '확인',
            onPressed: () {
              context
                  .read<ManageChallengeMemberBloc>()
                  .add(AssignmentAdminEvent(userId));
              context.pop();
              showDialog(
                context: context,
                builder: (context) => const SystemDialog(
                  subTitle: '방장 권한을 넘겼습니다.',
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void banishUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        subTitle: '해당 유저를 내보낼까요?',
        children: [
          SystemDialogButton(
            text: '취소',
            onPressed: context.pop,
            primary: false,
          ),
          SystemDialogButton(
            text: '내보내기',
            onPressed: () async {
              context
                  .read<ManageChallengeMemberBloc>()
                  .add(BanishUserEvent(userId));
              context.pop();
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
              context.push('/report/$userId');
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
                      onPressed: context.pop,
                    ),
                    SystemDialogButton(
                      text: '확인',
                      onPressed: () {
                        assignmentUser(context);
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
