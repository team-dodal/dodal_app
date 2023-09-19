import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

import 'feed_certification_modal.dart';

class CertificateFeedImage extends StatelessWidget {
  const CertificateFeedImage({super.key, required this.feed});

  final FeedItem feed;

  _showFeedModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FeedCertificationModal(feed: feed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showFeedModal(context);
      },
      child: Stack(
        children: [
          ImageWidget(
            image: feed.certImageUrl,
            width: double.infinity,
            height: double.infinity,
          ),
          const Positioned(
            bottom: 6,
            right: 6,
            child: CertMark(),
          )
        ],
      ),
    );
  }
}

class CertMark extends StatelessWidget {
  const CertMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Row(
        children: [
          Text(
            '인증 성공',
            style: context.caption(
              fontWeight: FontWeight.bold,
              color: AppColors.systemWhite,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.check_rounded,
            size: 18,
            color: AppColors.systemWhite,
          )
        ],
      ),
    );
  }
}
