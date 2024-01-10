import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/feed_content_box/continue_cert_box.dart';
import 'package:dodal_app/widgets/common/feed_content_box/feed_content_footer.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChallengeFeedScreen extends StatefulWidget {
  const ChallengeFeedScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  final int roomId;
  final String roomName;

  @override
  State<ChallengeFeedScreen> createState() => _ChallengeFeedScreenState();
}

class _ChallengeFeedScreenState extends State<ChallengeFeedScreen> {
  static const pageSize = 10;
  final PagingController<int, FeedContentResponse> pagingController =
      PagingController(firstPageKey: 0);

  _request(int pageKey) async {
    List<FeedContentResponse>? res = await FeedService.getFeedsByRoomId(
      page: pageKey,
      pageSize: pageSize,
      roomId: widget.roomId,
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
      appBar: AppBar(title: Text(widget.roomName)),
      body: PagedListView.separated(
        pagingController: pagingController,
        separatorBuilder: (context, index) {
          return const Divider(thickness: 8, color: AppColors.systemGrey4);
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
            return Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ImageWidget(
                          image: item.certImgUrl,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: ContinueCertBox(feedContent: item),
                      ),
                    ],
                  ),
                  FeedContentFooter(feedContent: item),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
