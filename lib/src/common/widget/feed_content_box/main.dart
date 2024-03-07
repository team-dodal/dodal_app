import 'package:dodal_app/src/common/model/feed_content_model.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:flutter/material.dart';

import 'continue_cert_box.dart';
import 'feed_content_footer.dart';
import 'feed_content_header.dart';

class FeedContentBox extends StatelessWidget {
  const FeedContentBox({super.key, required this.feedContent});

  final FeedContent feedContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FeedContentHeader(feedContent: feedContent),
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ImageWidget(
                  image: feedContent.certImgUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: ContinueCertBox(feedContent: feedContent),
              ),
            ],
          ),
          FeedContentFooter(feedContent: feedContent),
        ],
      ),
    );
  }
}
