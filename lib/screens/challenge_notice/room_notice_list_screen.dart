import 'package:dodal_app/screens/challenge_notice/create_notice_screen.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  Future<List<ChallengeRoomNoticeResponse>?> getNoticeList() async =>
      ChallengeService.getNoticeList(roomId: widget.id);

  final List<int> _openNoticeIndexList = [];

  _onExpansionChanged(bool isOpen, int index) {
    setState(() {
      if (isOpen) {
        _openNoticeIndexList.remove(index);
      } else {
        _openNoticeIndexList.add(index);
      }
    });
  }

  @override
  void initState() {
    if (widget.openIndex != null) {
      setState(() {
        _openNoticeIndexList.add(widget.openIndex!);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        actions: [
          if (widget.isAdmin)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateNoticeScreen(roomId: widget.id),
                ));
              },
              icon: const Icon(Icons.add),
            )
        ],
      ),
      body: FutureBuilder(
        future: getNoticeList(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }
          List<ChallengeRoomNoticeResponse> noticeList = snapshot.data!;

          return ListView.builder(
            itemCount: noticeList.length,
            itemBuilder: (context, index) {
              final isOpen = _openNoticeIndexList.contains(index);
              final timeStamp = DateFormat('yyyy.MM.dd a hh:mm', 'ko_KR');

              return ExpansionTile(
                title: Text(
                  noticeList[index].title,
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
                subtitle: !isOpen
                    ? Text(
                        timeStamp.format(noticeList[index].date),
                        style: context.caption(color: AppColors.systemGrey2),
                      )
                    : null,
                iconColor: AppColors.systemBlack,
                shape: const Border(),
                initiallyExpanded: isOpen,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                onExpansionChanged: (value) {
                  _onExpansionChanged(isOpen, index);
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
                            noticeList[index].content,
                            style: context.body4(color: AppColors.systemGrey1),
                          ),
                          const SizedBox(height: 10),
                          if (isOpen)
                            Text(
                              timeStamp.format(noticeList[index].date),
                              style:
                                  context.caption(color: AppColors.systemGrey2),
                            )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
