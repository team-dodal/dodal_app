import 'package:dodal_app/src/main/home/bloc/custom_challenge_list_bloc.dart';
import 'package:dodal_app/src/main/feed_list/bloc/feed_list_bloc.dart';
import 'package:dodal_app/src/main/my_challenge/bloc/my_challenge_list_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/main/my_info/bloc/user_room_feed_info_bloc.dart';
import 'package:dodal_app/src/main/root/page/main_route.dart';
import 'package:dodal_app/src/report/page/report_page.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberMenu extends StatelessWidget {
  const MemberMenu({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    challengeOut() async {
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
                    await ChallengeRepository.out(challengeId: challenge.id);
                if (!res) return;
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => CustomChallengeListBloc(
                              context
                                  .read<UserBloc>()
                                  .state
                                  .result!
                                  .categoryList,
                            ),
                          ),
                          BlocProvider(create: (context) => FeedListBloc()),
                          BlocProvider(
                              create: (context) => MyChallengeListBloc()),
                          BlocProvider(
                              create: (context) => UserRoomFeedInfoBloc()),
                        ],
                        child: const MainRoute(),
                      ),
                    ),
                    (route) => route.isFirst,
                  );
                }
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ListTile(
          title: const Text('나가기'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: challengeOut,
        ),
        ListTile(
          title: const Text('신고하기'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportPage(roomId: challenge.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
