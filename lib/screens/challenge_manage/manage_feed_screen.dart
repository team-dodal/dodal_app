import 'package:dodal_app/layout/modal_layout.dart';
import 'package:dodal_app/providers/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/providers/manage_challenge_member_bloc.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_settings/certificate_feed_image.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ManageFeedScreen extends StatefulWidget {
  const ManageFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<ManageFeedScreen> createState() => _ManageFeedScreenState();
}

class _ManageFeedScreenState extends State<ManageFeedScreen> {
  Widget _header() {
    return const Column(
      children: [InformationHeader(), DateChangeHeader()],
    );
  }

  Widget _empty() {
    return const Column(
      children: [SizedBox(height: 100), NoListContext(title: '피드가 존재하지 않습니다')],
    );
  }

  Widget _success(Map<String, List<FeedItem>> itemListByDate) {
    return ListView.builder(
      itemCount: itemListByDate.keys.length,
      itemBuilder: (context, index) {
        final dateKey = itemListByDate.keys.toList()[index];
        final feedList = itemListByDate[dateKey];
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
                for (final feed in feedList!) CertificateFeedImage(feed: feed)
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _header(),
        Expanded(
          child:
              BlocConsumer<ManageChallengeFeedBloc, ManageChallengeFeedState>(
            listener: (context, state) {
              if (state.status == ManageChallengeFeedStatus.success) {
                context
                    .read<ManageChallengeMemberBloc>()
                    .add(LoadManageChallengeMemberEvent());
              }
            },
            builder: (context, state) {
              switch (state.status) {
                case ManageChallengeFeedStatus.init:
                case ManageChallengeFeedStatus.loading:
                  return const Center(child: CupertinoActivityIndicator());
                case ManageChallengeFeedStatus.error:
                  return Center(child: Text(state.errorMessage!));
                case ManageChallengeFeedStatus.success:
                  if (state.itemListByDate.keys.isEmpty) return _empty();
                  return _success(state.itemListByDate);
              }
            },
          ),
        ),
      ],
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
  const DateChangeHeader({super.key});

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
              context.read<ManageChallengeFeedBloc>().add(ChangeMonthEvent(-1));
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.systemGrey2,
            ),
          ),
          BlocSelector<ManageChallengeFeedBloc, ManageChallengeFeedState,
              DateTime>(
            selector: (state) => state.date,
            builder: (context, state) {
              return Text(
                DateFormat('yyyy년 MM월').format(state),
                style: context.body1(),
              );
            },
          ),
          IconButton(
            onPressed: () {
              context.read<ManageChallengeFeedBloc>().add(ChangeMonthEvent(1));
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
