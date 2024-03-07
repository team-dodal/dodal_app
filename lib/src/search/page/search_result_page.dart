import 'package:animations/animations.dart';
import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/challenge/home/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/root/page/challenge_root_page.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/challenge_list/widget/filter_top_bar.dart';
import 'package:dodal_app/src/common/widget/challenge_box/list_challenge_box.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key, required this.word});

  final String word;

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  static const pageSize = 20;
  final PagingController<int, Challenge> pagingController =
      PagingController(firstPageKey: 0);

  _request(int pageKey) async {
    final state = BlocProvider.of<ChallengeListFilterCubit>(context).state;
    try {
      List<Challenge> res = await ChallengeRepository.getChallengesByKeyword(
        word: widget.word,
        conditionCode: state.condition.index,
        certCntList: state.certCntList,
        page: pageKey,
        pageSize: pageSize,
      );
      final isLastPage = res.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(res);
      } else {
        final nextPageKey = pageKey + res.length;
        pagingController.appendPage(res, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    pagingController.addPageRequestListener(_request);
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SearchAppBar(word: widget.word)),
      body: BlocListener<ChallengeListFilterCubit, ChallengeListFilterState>(
        listener: (context, state) {
          pagingController.refresh();
        },
        child: BlocBuilder<ChallengeListFilterCubit, ChallengeListFilterState>(
          builder: (context, state) {
            return PagedListView<int, Challenge>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<Challenge>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FilterTopBar(),
                      const SizedBox(height: 130),
                      NoListContext(
                        title: '카테고리 관련 도전이 없습니다.',
                        subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
                        buttonText: '도전 생성하기',
                        onButtonPress: () {
                          context.push('create-challenge');
                        },
                      ),
                    ],
                  );
                },
                itemBuilder: (context, item, index) {
                  return Column(
                    children: [
                      if (index == 0) const FilterTopBar(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: OpenContainer(
                          transitionType: ContainerTransitionType.fadeThrough,
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
                          openBuilder: (context, action) => BlocProvider(
                            create: (context) => ChallengeInfoBloc(item.id),
                            child: const ChallengeRootPage(),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key, required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
