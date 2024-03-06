import 'package:dodal_app/model/feed_content_model.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/widgets/common/feed_content_box/feed_content_footer.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

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
        future: FeedService.getOneFeedById(feedId: feedId),
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
              FeedContentFooter(feedContent: feed)
            ],
          );
        },
      ),
    );
  }
}
