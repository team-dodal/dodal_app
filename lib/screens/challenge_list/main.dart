import 'package:dodal_app/widgets/challenge_list/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({
    super.key,
  });

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen>
    with TickerProviderStateMixin {
  static const pageSize = 20;
  final PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 0);

  _request(int pageKey) async {}

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
      // body: PagedListView<int, dynamic>(
      //   pagingController: pagingController,
      //   builderDelegate: PagedChildBuilderDelegate<dynamic>(
      //     itemBuilder: (context, item, index) {
      //       return const Text('data');
      //     },
      //   ),
      // ),
    );
  }
}
