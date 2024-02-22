import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/providers/bookmark_bloc.dart';
import 'package:dodal_app/providers/challenge_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/notification_list_bloc.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/screens/notification/main.dart';
import 'package:dodal_app/screens/search/main.dart';
import 'package:dodal_app/widgets/challenge_list/list_tab_bar.dart';
import 'package:dodal_app/widgets/common/challenge_box/list_challenge_box.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen> {
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
            openBuilder: (context, action) =>
                ChallengeRoute(id: challenges[index].id),
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => BlocProvider(
              create: (context) => CreateChallengeBloc(),
              child: const CreateChallengeScreen(),
            ),
          ));
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
              Navigator.of(context).push(
                SlidePageRoute(screen: const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                SlidePageRoute(
                  screen: BlocProvider(
                    create: (context) => NotificationListBloc(
                      userId: context.read<UserBloc>().state.result!.id,
                    ),
                    child: const NotiFicationScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                SlidePageRoute(
                  screen: BlocProvider(
                    create: (context) => CreateChallengeBloc(),
                    child: const CreateChallengeScreen(),
                  ),
                ),
              );
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
              case ChallengeListStatus.init:
                return const Center(child: CupertinoActivityIndicator());
              case ChallengeListStatus.loading:
              case ChallengeListStatus.success:
                if (state.result.isEmpty) {
                  return _empty();
                } else {
                  return _challengeList(state.result);
                }
              case ChallengeListStatus.error:
                return Center(child: Text(state.errorMessage!));
            }
          },
        ),
      ),
    );
  }
}
