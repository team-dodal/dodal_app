import 'package:dodal_app/layout/modal_layout.dart';
import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

class FeedCertificationModal extends StatelessWidget {
  const FeedCertificationModal({
    super.key,
    required this.feed,
    required this.getFeeds,
  });

  final FeedItem feed;
  final Future<void> Function() getFeeds;

  _request(BuildContext context, bool value) async {
    final res = await ManageChallengeService.approveOrRejectFeed(
      roomId: feed.challengeRoomId!,
      feedId: feed.challengeFeedId!,
      confirmValue: value,
    );
    if (res == null) return;
    if (context.mounted) {
      Navigator.pop(context);
      await getFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AvatarImage(image: null, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Text(
                    feed.requestUserNickname!,
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1,
            child: ImageWidget(
              image: feed.certImageUrl,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Text(feed.certContent!),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.systemGrey3),
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: feed.certCode == CertCode.fail.index.toString()
                      ? null
                      : () => _request(context, false),
                  child: Text(
                    '거절',
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton(
                  onPressed: feed.certCode == CertCode.success.index.toString()
                      ? null
                      : () => _request(context, true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                  child: Text(
                    '승인',
                    style: context.body2(
                      fontWeight: FontWeight.bold,
                      color: AppColors.systemWhite,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
