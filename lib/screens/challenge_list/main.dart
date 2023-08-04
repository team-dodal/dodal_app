import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/services/challenge_service.dart';
import 'package:dodal_app/widgets/challenge_list/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen>
    with TickerProviderStateMixin {
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
      body: BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
        builder: (context, state) {
          return PagedListView<int, Challenge>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<Challenge>(
              itemBuilder: (context, item, index) {
                return Text(item.title);
              },
            ),
          );
        },
      ),
    );
  }
}
