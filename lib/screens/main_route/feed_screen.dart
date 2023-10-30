import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/widgets/common/cross_divider.dart';
import 'package:dodal_app/widgets/common/feed_content_box/main.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const pageSize = 10;
  final PagingController<int, FeedContentResponse> pagingController =
      PagingController(firstPageKey: 0);

  _request(int pageKey) async {
    List<FeedContentResponse>? res =
        await FeedService.getAllFeeds(page: pageKey, pageSize: pageSize);
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
    return PagedListView.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) {
        return const CrossDivider();
      },
      builderDelegate: PagedChildBuilderDelegate(
        noItemsFoundIndicatorBuilder: (context) {
          return const Column(
            children: [
              SizedBox(height: 100),
              NoListContext(
                title: '아직 업로드된 피드가 없습니다.',
                subTitle: '내가 먼저 업로드해보는건 어떨까요?',
              ),
            ],
          );
        },
        itemBuilder: (context, FeedContentResponse item, index) {
          return FeedContentBox(feedContent: item);
        },
      ),
    );
  }
}
