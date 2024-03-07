import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/challenge/manage/bloc/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/src/challenge/manage/bloc/manage_challenge_member_bloc.dart';
import 'package:dodal_app/src/challenge/manage/page/challenge_manage_page.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_route.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('도전 상세 정보 편집'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CreateChallengeBloc(
                    roomId: challenge.id,
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
                  child: const CreateChallengeRoute(),
                ),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('도전 인증 관리'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          ManageChallengeMemberBloc(challenge.id),
                    ),
                    BlocProvider(
                      create: (context) =>
                          ManageChallengeFeedBloc(challenge.id),
                    ),
                  ],
                  child: ChallengeManagePage(
                    index: 0,
                    challenge: challenge,
                  ),
                ),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('도전 멤버 관리'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          ManageChallengeMemberBloc(challenge.id),
                    ),
                    BlocProvider(
                      create: (context) =>
                          ManageChallengeFeedBloc(challenge.id),
                    ),
                  ],
                  child: ChallengeManagePage(
                    index: 1,
                    challenge: challenge,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
