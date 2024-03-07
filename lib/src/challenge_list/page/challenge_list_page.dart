import 'package:animations/animations.dart';
import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/challenge/home/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/root/page/challenge_root_page.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_bloc.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/challenge_list/widget/list_tab_bar.dart';
import 'package:dodal_app/src/common/widget/challenge_box/list_challenge_box.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChallengeListPage extends StatefulWidget {
  const ChallengeListPage({super.key});

  @override
  State<ChallengeListPage> createState() => _ChallengeListPageState();
}

class _ChallengeListPageState extends State<ChallengeListPage> {
  ScrollController scrollController = ScrollController();

  Widget _challengeList(List<Challenge> challenges) {
    return ListView.builder(
      controller: scrollController,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            closedElevation: 0,
            closedBuilder: (context, action) {
              return InkWell(
                onTap: action,
                child: BlocProvider(
                  create: (context) => BookmarkBloc(
                    roomId: challenges[index].id,
                    isBookmarked: challenges[index].isBookmarked,
                  ),
                  child: ListChallengeBox(
                    title: challenges[index].title,
                    tag: challenges[index].tag,
                    thumbnailImg: challenges[index].thumbnailImg,
                    adminProfile: challenges[index].adminProfile,
                    adminNickname: challenges[index].adminNickname,
                    userCnt: challenges[index].userCnt,
                    certCnt: challenges[index].certCnt,
                    recruitCnt: challenges[index].recruitCnt,
                  ),
                ),
              );
            },
            openBuilder: (context, action) => BlocProvider(
              create: (context) => ChallengeInfoBloc(challenges[index].id),
              child: const ChallengeRootPage(),
            ),
          ),
        );
      },
      itemCount: challenges.length,
    );
  }

  Widget _empty() {
    return Center(
      child: NoListContext(
        title: '카테고리 관련 도전이 없습니다.',
        subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
        buttonText: '도전 생성하기',
        onButtonPress: () {
          context.push('/create-challenge');
        },
      ),
    );
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        final filterState = context.read<ChallengeListFilterCubit>().state;
        context.read<ChallengeListBloc>().add(
              LoadChallengeListEvent(
                category: filterState.category,
                tag: filterState.tag,
                condition: filterState.condition,
                certCntList: filterState.certCntList,
              ),
            );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const ListTabBar(),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              context.push('/notification');
            },
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {
              context.push('/create-challenge');
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: BlocListener<ChallengeListFilterCubit, ChallengeListFilterState>(
        listener: (context, state) {
          context.read<ChallengeListBloc>().add(ResetChallengeListEvent());
          context.read<ChallengeListBloc>().add(LoadChallengeListEvent(
                category: state.category,
                tag: state.tag,
                condition: state.condition,
                certCntList: state.certCntList,
              ));
        },
        child: BlocBuilder<ChallengeListBloc, ChallengeListState>(
          builder: (context, state) {
            switch (state.status) {
              case CommonStatus.init:
                return const Center(child: CupertinoActivityIndicator());
              case CommonStatus.loading:
              case CommonStatus.loaded:
                if (state.result.isEmpty) {
                  return _empty();
                } else {
                  return _challengeList(state.result);
                }
              case CommonStatus.error:
                return Center(child: Text(state.errorMessage!));
            }
          },
        ),
      ),
    );
  }
}
