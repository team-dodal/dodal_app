import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
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
    return ListView.builder(
      itemCount: _itemListByDate.keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DateChangeHeader(date: _date, changeHandler: _changeDate),
          );
        } else {
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
                    ImageWidget(
                      image: feed.certImageUrl,
                      width: double.infinity,
                      height: double.infinity,
                    )
                ],
              ),
            ],
          );
        }
      },
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
    return Row(
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
    );
  }
}
