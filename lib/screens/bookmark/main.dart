import 'package:animations/animations.dart';
import 'package:dodal_app/providers/my_bookmark_list_cubit.dart';
import 'package:dodal_app/screens/challenge_preview/main.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/widgets/common/challenge_box/grid_challenge_box.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('북마크')),
      body: BlocBuilder<MyBookmarkListCubit, MyBookmarkListState>(
        builder: (context, state) {
          if (state.status == MyBookmarkListStatus.success) {
            if (state.result.isEmpty) {
              return const NoListContext(
                title: '북마크한 모임이 없습니다',
                subTitle: '마음에 드는 모임을 찾아보세요!',
              );
            } else {
              return GridView.count(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                childAspectRatio: 0.8,
                children: [
                  for (final challenge in state.result)
                    OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedElevation: 0,
                      closedBuilder: (context, action) {
                        return Container(
                          constraints: const BoxConstraints(minHeight: 80),
                          child: GridChallengeBox(challenge: challenge),
                        );
                      },
                      openBuilder: (context, action) => challenge.isJoined
                          ? ChallengeRoute(id: challenge.id)
                          : ChallengePreviewScreen(id: challenge.id),
                    ),
                ],
              );
            }
          }

          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}
