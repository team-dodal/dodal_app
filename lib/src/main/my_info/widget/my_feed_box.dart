import 'package:dodal_app/src/common/bloc/feed_like_cubit.dart';
import 'package:dodal_app/src/common/model/feed_content_model.dart';
import 'package:dodal_app/src/common/repositories/feed_repository.dart';
import 'package:dodal_app/src/common/widget/feed_content_box/feed_content_footer.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFeedBox extends StatelessWidget {
  const MyFeedBox({super.key, required this.feedId});

  final int feedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 쓴 글'),
      ),
      body: FutureBuilder(
        future: FeedRepository.getOneFeedById(feedId: feedId),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.data == null) {
            return const SizedBox();
          }
          FeedContent feed = state.data!;
          return Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ImageWidget(
                  image: feed.certImgUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              BlocProvider(
                create: (context) => FeedReactCubit(
                  feed.feedId,
                  isLiked: feed.likeYn,
                  likeCount: feed.likeCnt,
                  commentCount: feed.commentCnt,
                ),
                child: FeedContentFooter(feedContent: feed),
              ),
            ],
          );
        },
      ),
    );
  }
}
