import 'package:animations/animations.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/screens/challenge_preview/main.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/challenge_list/challenge_box.dart';
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
      conditionCode: state.conditionCode,
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
    pagingController.addPageRequestListener((pageKey) {
      _request(pageKey);
    });

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
      appBar: AppBar(bottom: const ListTabBar()),
      body: BlocListener<ChallengeListFilterCubit, ChallengeListFilter>(
          listener: (context, state) {
        pagingController.refresh();
      }, child: BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
              builder: (context, state) {
        return PagedListView<int, Challenge>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Challenge>(
            noItemsFoundIndicatorBuilder: (context) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterTopBar(),
                  SizedBox(height: 130),
                  NoListContext(
                    title: '카테고리 관련 도전이 없습니다.',
                    subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
                  ),
                ],
              );
            },
            itemBuilder: (context, item, index) {
              return Column(
                children: [
                  if (index == 0) const FilterTopBar(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder: (context, action) {
                        return InkWell(
                          onTap: action,
                          child: ChallengeBox(
                            title: item.title,
                            tag: item.tag,
                            thumbnailImg: item.thumbnailImg,
                            adminProfile: item.adminProfile,
                            adminNickname: item.adminNickname,
                            userCnt: item.userCnt,
                            certCnt: item.certCnt,
                            recruitCnt: item.recruitCnt,
                          ),
                        );
                      },
                      openBuilder: (context, action) =>
                          ChallengePreviewScreen(id: item.id),
                    ),
                  )
                ],
              );
            },
          ),
        );
      })),
    );
  }
}
