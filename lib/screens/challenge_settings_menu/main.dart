import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/challenge_settings_menu/challenge_report_screen.dart';
import 'package:dodal_app/screens/challenge_settings_menu/manage_feed_screen.dart';
import 'package:dodal_app/screens/challenge_settings_menu/manage_member_screen.dart';
import 'package:dodal_app/screens/challenge_settings_menu/modify_challenge_screen.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSettingsMenuScreen extends StatelessWidget {
  const GroupSettingsMenuScreen({
    super.key,
    required this.challenge,
  });

  final OneChallengeResponse challenge;

  @override
  Widget build(BuildContext context) {
    final userId = BlocProvider.of<UserCubit>(context).state!.id;
    bool isHost = challenge.hostId == userId;

    List<Widget> adminList = [
      ListTile(
        title: const Text('도전 상세 정보 편집'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ModifyChallengeScreen(),
          ));
        },
      ),
      ListTile(
        title: const Text('도전 인증 관리'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ManageFeedScreen(),
          ));
        },
      ),
      ListTile(
        title: const Text('도전 멤버 관리'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ManageMemberScreen(),
          ));
        },
      ),
      Container(
        height: 8,
        decoration: const BoxDecoration(color: AppColors.bgColor2),
      ),
      ListTile(
        title: const Text('도전 그룹 삭제하기'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {},
      ),
    ];

    List<Widget> userList = [
      ListTile(
        title: const Text('나가기'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) => SystemDialog(
              title: '정말로 나가시겠습니까?',
              children: [
                SystemDialogButton(
                  text: '취소',
                  primary: false,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SystemDialogButton(
                  text: '나가기',
                  onPressed: () async {
                    await ChallengeService.out(challengeId: challenge.id);
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainRoute(),
                        ),
                        (route) => route.isFirst,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      ListTile(
        title: const Text('신고하기'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext ctx) => const ChallengeReportScreen(),
          ));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
      ),
      body: Column(children: isHost ? adminList : userList),
    );
  }
}
