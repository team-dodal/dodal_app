import 'package:animations/animations.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/challenge/home/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/root/page/challenge_root_page.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/challenge_list/widget/filter_top_bar.dart';
import 'package:dodal_app/src/common/widget/challenge_box/list_challenge_box.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:dodal_app/src/search/bloc/search_result_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  ScrollController scrollController = ScrollController();

  Widget _empty() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 130),
        NoListContext(
          title: '카테고리 관련 도전이 없습니다.',
          subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
          buttonText: '도전 생성하기',
          onButtonPress: () {
            context.push('/create-challenge');
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        final filterState = context.read<ChallengeListFilterCubit>().state;
        context
            .read<SearchResultListCubit>()
            .addData(filterState.condition, filterState.certCntList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _SearchAppBar(
          word: context.read<SearchResultListCubit>().state.word,
        ),
      ),
      body: Column(
        children: [
          BlocListener<ChallengeListFilterCubit, ChallengeListFilterState>(
            listener: (context, state) {
              context
                  .read<SearchResultListCubit>()
                  .refreshData(state.condition, state.certCntList);
            },
            child: const FilterTopBar(),
          ),
          BlocBuilder<SearchResultListCubit, SearchResultListState>(
            builder: (context, state) {
              switch (state.status) {
                case CommonStatus.init:
                case CommonStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case CommonStatus.error:
                  return Center(child: Text(state.errorMessage!));
                case CommonStatus.loaded:
                  if (state.items.isEmpty) {
                    return _empty();
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: OpenContainer(
                                  transitionType:
                                      ContainerTransitionType.fadeThrough,
                                  closedElevation: 0,
                                  closedBuilder: (context, action) {
                                    return InkWell(
                                      onTap: action,
                                      child: BlocProvider(
                                        create: (context) => BookmarkBloc(
                                          roomId: item.id,
                                          isBookmarked: item.isBookmarked,
                                        ),
                                        child: ListChallengeBox(
                                          title: item.title,
                                          tag: item.tag,
                                          thumbnailImg: item.thumbnailImg,
                                          adminProfile: item.adminProfile,
                                          adminNickname: item.adminNickname,
                                          userCnt: item.userCnt,
                                          certCnt: item.certCnt,
                                          recruitCnt: item.recruitCnt,
                                        ),
                                      ),
                                    );
                                  },
                                  openBuilder: (context, action) =>
                                      BlocProvider(
                                    create: (context) =>
                                        ChallengeInfoBloc(item.id),
                                    child: const ChallengeRootPage(),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SearchAppBar extends StatelessWidget {
  const _SearchAppBar({required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.replace('/search');
      },
      child: Container(
        height: 42,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: AppColors.systemGrey4,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Text(word, style: context.body4()),
      ),
    );
  }
}
