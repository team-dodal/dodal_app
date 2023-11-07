import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/challenge_settings_menu/manage_route/manage_route.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
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

    List<Map<String, dynamic>> adminItemList = [
      {
        'name': '도전 상세 정보 편집',
        'page': BlocProvider(
          create: (context) => CreateChallengeCubit(
            title: challenge.title,
            content: challenge.content,
            certContent: challenge.certContent,
            tagValue: challenge.tag,
            thumbnailImg: challenge.thumbnailImgUrl,
            certCorrectImg: challenge.certCorrectImgUrl,
            certWrongImg: challenge.certWrongImgUrl,
            recruitCnt: challenge.recruitCnt,
            certCnt: challenge.certCnt,
          ),
          child: CreateChallengeScreen(roomId: challenge.id),
        ),
      },
      {
        'name': '도전 인증 관리',
        'page': ManageRoute(index: 0, challenge: challenge),
      },
      {
        'name': '도전 멤버 관리',
        'page': ManageRoute(index: 1, challenge: challenge),
      },
      {
        'name': '도전 그룹 삭제하기',
        'action': () {},
      },
    ];

    List<Map<String, dynamic>> userItemList = [
      {
        'name': '나가기',
        'action': () async {
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
                    final res =
                        await ChallengeService.out(challengeId: challenge.id);
                    if (!res) return;
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
      },
      {
        'name': '신고하기',
        'page': const ReportScreen(),
      },
    ];

    List<Map<String, dynamic>> list = isHost ? adminItemList : userItemList;
    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
      ),
      body: Column(
        children: list
            .map((item) => ListTile(
                  title: Text(item['name']),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    if (item['page'] != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => item['page'],
                      ));
                    } else {
                      item['action']();
                    }
                  },
                ))
            .toList(),
      ),
    );
  }
}
