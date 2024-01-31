import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/notification_list_bloc.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/challenge_preview/main.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/screens/notification/main.dart';
import 'package:dodal_app/screens/search/main.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/common/challenge_box/list_challenge_box.dart';
import 'package:dodal_app/widgets/challenge_list/filter_top_bar.dart';
import 'package:dodal_app/widgets/challenge_list/list_tab_bar.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen> {
  static const pageSize = 20;
  final PagingController<int, Challenge> pagingController =
      PagingController(firstPageKey: 0);

  _request(int pageKey) async {
    final state = BlocProvider.of<ChallengeListFilterCubit>(context).state;
    List<Challenge>? res = await ChallengeService.getChallengesByCategory(
      categoryValue: state.category.value,
      tagValue: state.tag.value,
      conditionCode: state.condition.index,
      certCntList: state.certCntList,
      page: pageKey,
      pageSize: pageSize,
    );
    if (res == null) return;
    final isLastPage = res.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(res);
    } else {
      final nextPageKey = pageKey + res.length;
      pagingController.appendPage(res, nextPageKey);
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
                    create: (context) => CreateChallengeCubit(),
                    child: const CreateChallengeScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: BlocConsumer<ChallengeListFilterCubit, ChallengeListFilter>(
        listener: (context, state) {
          pagingController.refresh();
        },
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => BlocProvider(
                              create: (context) => CreateChallengeCubit(),
                              child: const CreateChallengeScreen(),
                            ),
                          ),
                        );
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
                            child: ListChallengeBox(
                              id: item.id,
                              title: item.title,
                              tag: item.tag,
                              thumbnailImg: item.thumbnailImg,
                              adminProfile: item.adminProfile,
                              adminNickname: item.adminNickname,
                              userCnt: item.userCnt,
                              certCnt: item.certCnt,
                              recruitCnt: item.recruitCnt,
                              isBookmarked: item.isBookmarked,
                            ),
                          );
                        },
                        openBuilder: (context, action) => item.isJoined
                            ? ChallengeRoute(id: item.id)
                            : ChallengePreviewScreen(id: item.id),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
