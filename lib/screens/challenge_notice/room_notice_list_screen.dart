import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/providers/challenge_notice_list_bloc.dart';
import 'package:dodal_app/providers/create_challenge_notice_bloc.dart';
import 'package:dodal_app/screens/challenge_notice/create_notice_screen.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomNoticeListScreen extends StatefulWidget {
  const RoomNoticeListScreen({
    super.key,
    required this.id,
    this.openIndex,
    required this.isAdmin,
  });

  final int id;
  final int? openIndex;
  final bool isAdmin;

  @override
  State<RoomNoticeListScreen> createState() => _RoomNoticeListScreenState();
}

class _RoomNoticeListScreenState extends State<RoomNoticeListScreen> {
  void _goCreateNoticeScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => CreateChallengeNoticeBloc(roomId: widget.id),
              child: CreateNoticeScreen(roomId: widget.id)),
        )).then((value) {
      context
          .read<ChallengeNoticeListBloc>()
          .add(LoadChallengeNoticeListEvent());
    });
  }

  Column _empty() {
    return const Column(
      children: [
        SizedBox(height: 100),
        Center(
          child: NoListContext(
            title: '알림',
            subTitle: '작성된 공지사항이 없습니다.',
          ),
        ),
      ],
    );
  }

  ListView _success(ChallengeNoticeListState state) {
    return ListView.builder(
      itemCount: state.noticeList.length,
      itemBuilder: (context, index) {
        final isOpen = state.openIndexList.contains(index);

        return ExpansionTile(
          title: Text(
            state.noticeList[index].title,
            style: context.body1(fontWeight: FontWeight.bold),
          ),
          subtitle: !isOpen
              ? Text(
                  state.noticeList[index].date,
                  style: context.caption(color: AppColors.systemGrey2),
                )
              : null,
          iconColor: AppColors.systemBlack,
          shape: const Border(),
          initiallyExpanded: isOpen,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          onExpansionChanged: (value) {
            context
                .read<ChallengeNoticeListBloc>()
                .add(ChangeTargetIndexEvent(index));
          },
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.noticeList[index].content,
                      style: context.body4(color: AppColors.systemGrey1),
                    ),
                    const SizedBox(height: 10),
                    if (isOpen)
                      Text(
                        state.noticeList[index].date,
                        style: context.caption(color: AppColors.systemGrey2),
                      )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        actions: [
          if (widget.isAdmin)
            IconButton(
              onPressed: _goCreateNoticeScreen,
              icon: const Icon(Icons.add),
            )
        ],
      ),
      body: BlocBuilder<ChallengeNoticeListBloc, ChallengeNoticeListState>(
        builder: (context, state) {
          switch (state.status) {
            case CommonStatus.init:
            case CommonStatus.loading:
              return const Center(child: CupertinoActivityIndicator());
            case CommonStatus.error:
              return Center(child: Text(state.errorMessage!));
            case CommonStatus.loaded:
              if (state.noticeList.isEmpty) {
                return _empty();
              }
              return _success(state);
          }
        },
      ),
    );
  }
}
