import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:dodal_app/widgets/common/cross_divider.dart';
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
                return const SizedBox();
              }
              if (state.data == null) {
                return const SizedBox();
              }
              FeedContentResponse feed = state.data!;
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(feed.certContent),
                      ),
                    ],
                  ),
                  const CrossDivider()
                ],
              );
            }));
  }
}
