import 'package:dodal_app/src/challenge/feed/bloc/challenge_feed_cubit.dart';
import 'package:dodal_app/src/common/bloc/feed_like_cubit.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/feed_content_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/widget/feed_content_box/continue_cert_box.dart';
import 'package:dodal_app/src/common/widget/feed_content_box/feed_content_footer.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeFeedPage extends StatefulWidget {
  const ChallengeFeedPage({super.key, required this.roomName});

  final String roomName;

  @override
  State<ChallengeFeedPage> createState() => _ChallengeFeedPageState();
}

class _ChallengeFeedPageState extends State<ChallengeFeedPage> {
  ScrollController scrollController = ScrollController();

  Widget _empty() {
    return const Center(
      child: NoListContext(
        title: '아직 업로드된 피드가 없습니다.',
        subTitle: '내가 먼저 업로드해보는건 어떨까요?',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<ChallengeFeedCubit>().load();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomName)),
      body: BlocBuilder<ChallengeFeedCubit, ChallengeFeedState>(
        builder: (context, state) {
          switch (state.status) {
            case CommonStatus.init:
            case CommonStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CommonStatus.error:
              return Center(child: Text(state.errorMessage!));
            case CommonStatus.loaded:
              if (state.feedList.isEmpty) {
                return _empty();
              } else {
                return _FeedListView(list: state.feedList);
              }
          }
        },
      ),
    );
  }
}

class _FeedListView extends StatelessWidget {
  const _FeedListView({required this.list});

  final List<FeedContent> list;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) {
        return const Divider(thickness: 8, color: AppColors.systemGrey4);
      },
      itemBuilder: (context, index) {
        return Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ImageWidget(
                    image: list[index].certImgUrl,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: ContinueCertBox(feedContent: list[index]),
                ),
              ],
            ),
            BlocProvider(
              create: (context) => FeedReactCubit(
                list[index].feedId,
                isLiked: list[index].likeYn,
                likeCount: list[index].likeCnt,
                commentCount: list[index].commentCnt,
              ),
              child: FeedContentFooter(feedContent: list[index]),
            ),
          ],
        );
      },
    );
  }
}
