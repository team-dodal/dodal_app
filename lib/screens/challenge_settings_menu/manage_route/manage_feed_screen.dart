import 'package:dodal_app/layout/modal_layout.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_settings/certificate_feed_image.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageFeedScreen extends StatefulWidget {
  const ManageFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<ManageFeedScreen> createState() => _ManageFeedScreenState();
}

class _ManageFeedScreenState extends State<ManageFeedScreen> {
  DateTime _date = DateTime.now();
  Map<String, List<FeedItem>> _itemListByDate = {};

  _request(DateTime date) async {
    String formattedDate = DateFormat('yyyyMM').format(date);

    final res = await ManageChallengeService.getCertificationList(
      roomId: widget.challenge.id,
      dateYM: formattedDate,
    );
    if (res == null) return;
    setState(() {
      _itemListByDate = res;
    });
  }

  _changeDate(int month) {
    final changedDate = DateTime(_date.year, _date.month + month, _date.day);
    if (changedDate.isAfter(DateTime.now())) return;
    _request(changedDate);
    _date = changedDate;
  }

  @override
  void initState() {
    _request(_date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget header = Column(
      children: [
        const InformationHeader(),
        DateChangeHeader(date: _date, changeHandler: _changeDate),
      ],
    );

    if (_itemListByDate.keys.isEmpty) {
      return Column(
        children: [
          header,
          const SizedBox(height: 100),
          const NoListContext(title: '피드가 존재하지 않습니다')
        ],
      );
    }

    return ListView.builder(
      itemCount: _itemListByDate.keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return header;

        final dateKey = _itemListByDate.keys.toList()[index - 1];
        final feedList = _itemListByDate[dateKey];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              dateKey,
              style: context.body2(color: AppColors.systemGrey1),
            ),
            GridView.count(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              shrinkWrap: true,
              children: [
                for (final feed in feedList!)
                  CertificateFeedImage(
                    feed: feed,
                    getFeeds: () async {
                      await _request(_date);
                    },
                  )
              ],
            ),
          ],
        );
      },
    );
  }
}

class InformationHeader extends StatelessWidget {
  const InformationHeader({super.key});

  _moreInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ModalLayout(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close_rounded),
              )
            ],
          ),
          Image.asset('assets/images/user_manage_example.png'),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.systemGrey4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error,
                color: AppColors.systemGrey1,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '멤버들의 인증을 쉽게 관리해 보세요!',
                style: context.caption(),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              _moreInfoModal(context);
            },
            style: IconButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            icon: Row(
              children: [
                Text(
                  '자세히보기',
                  style: context.body4(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DateChangeHeader extends StatelessWidget {
  const DateChangeHeader({
    super.key,
    required this.changeHandler,
    required this.date,
  });

  final void Function(int) changeHandler;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              changeHandler(-1);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.systemGrey2,
            ),
          ),
          Text(
            DateFormat('yyyy년 MM월').format(date),
            style: context.body1(),
          ),
          IconButton(
            onPressed: () {
              changeHandler(1);
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.systemGrey2,
            ),
          ),
        ],
      ),
    );
  }
}
