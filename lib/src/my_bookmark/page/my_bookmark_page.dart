import 'package:animations/animations.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/challenge/home/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/root/page/challenge_root_page.dart';
import 'package:dodal_app/src/my_bookmark/bloc/my_bookmark_cubit.dart';
import 'package:dodal_app/src/common/widget/challenge_box/grid_challenge_box.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBookmarkPage extends StatelessWidget {
  const MyBookmarkPage({super.key});

  Widget _success(MyBookmarkListState state) {
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
                child: BlocProvider(
                  create: (context) => BookmarkBloc(
                      roomId: challenge.id,
                      isBookmarked: true,
                      successCallback: (roomId) {
                        context.read<MyBookmarkCubit>().removeItem(roomId);
                      }),
                  child: GridChallengeBox(challenge: challenge),
                ),
              );
            },
            openBuilder: (context, action) => BlocProvider(
              create: (context) => ChallengeInfoBloc(challenge.id),
              child: const ChallengeRootPage(),
            ),
          ),
      ],
    );
  }

  Widget _empty() {
    return const Column(
      children: [
        SizedBox(height: 100),
        Center(
          child: NoListContext(
            title: '북마크한 모임이 없습니다',
            subTitle: '마음에 드는 모임을 찾아보세요!',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('북마크')),
      body: BlocBuilder<MyBookmarkCubit, MyBookmarkListState>(
        builder: (context, state) {
          switch (state.status) {
            case CommonStatus.init:
            case CommonStatus.loading:
              return const Center(child: CupertinoActivityIndicator());
            case CommonStatus.error:
              return Center(child: Text(state.errorMessage!));
            case CommonStatus.loaded:
              if (state.result.isEmpty) {
                return _empty();
              } else {
                return _success(state);
              }
          }
        },
      ),
    );
  }
}
