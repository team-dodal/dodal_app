import 'package:dodal_app/src/common/bloc/feed_like_cubit.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/widget/feed_content_box/feed_content_footer.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:dodal_app/src/main/my_info/bloc/my_feed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFeedPage extends StatelessWidget {
  const MyFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내가 쓴 글')),
      body: BlocBuilder<MyFeedCubit, MyFeedState>(
        builder: (context, state) {
          switch (state.status) {
            case CommonStatus.init:
            case CommonStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CommonStatus.error:
              return Center(child: Text(state.errorMessage!));
            case CommonStatus.loaded:
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ImageWidget(
                      image: state.item!.certImgUrl,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => FeedReactCubit(
                      state.item!.feedId,
                      isLiked: state.item!.likeYn,
                      likeCount: state.item!.likeCnt,
                      commentCount: state.item!.commentCnt,
                    ),
                    child: FeedContentFooter(feedContent: state.item!),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
