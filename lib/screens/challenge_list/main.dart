import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/services/challenge_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/challenge_box.dart';
import 'package:dodal_app/widgets/challenge_list/list_tab_bar.dart';
import 'package:dodal_app/widgets/challenge_list/sort_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  _showBottomSheet() {
    ChallengeListFilter cubit =
        BlocProvider.of<ChallengeListFilterCubit>(context).state;

    onChanged(value) {
      context.read<ChallengeListFilterCubit>().updateData(conditionCode: value);
      Navigator.pop(context);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SortBottomSheet(
        cubit: cubit,
        onChanged: onChanged,
      ),
    );
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
              return Column(
                children: [
                  Container(height: 8, color: AppColors.basicColor2),
                ],
              );
            },
            itemBuilder: (context, item, index) {
              return Column(
                children: [
                  if (index == 0)
                    Column(
                      children: [
                        Container(height: 8, color: AppColors.basicColor2),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _showBottomSheet,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/swap_icon.svg'),
                                  const SizedBox(width: 4),
                                  Text(
                                    CONDITION_LIST[state.conditionCode],
                                    style: Typo(context)
                                        .body4()!
                                        .copyWith(color: AppColors.systemGrey1),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
