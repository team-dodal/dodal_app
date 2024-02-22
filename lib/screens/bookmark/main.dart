import 'package:animations/animations.dart';
import 'package:dodal_app/providers/bookmark_bloc.dart';
import 'package:dodal_app/providers/challenge_info_bloc.dart';
import 'package:dodal_app/providers/my_bookmark_list_cubit.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/widgets/common/challenge_box/grid_challenge_box.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

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
                        context.read<MyBookmarkListCubit>().removeItem(roomId);
                      }),
                  child: GridChallengeBox(challenge: challenge),
                ),
              );
            },
            openBuilder: (context, action) => BlocProvider(
              create: (context) => ChallengeInfoBloc(challenge.id),
              child: const ChallengeRoute(),
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
      body: BlocBuilder<MyBookmarkListCubit, MyBookmarkListState>(
        builder: (context, state) {
          switch (state.status) {
            case MyBookmarkListStatus.init:
            case MyBookmarkListStatus.loading:
              return const Center(child: CupertinoActivityIndicator());
            case MyBookmarkListStatus.error:
              return Center(child: Text(state.errorMessage!));
            case MyBookmarkListStatus.success:
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
