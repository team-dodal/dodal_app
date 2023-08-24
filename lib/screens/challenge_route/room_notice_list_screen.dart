import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomNoticeListScreen extends StatefulWidget {
  const RoomNoticeListScreen({super.key, required this.id});

  final int id;

  @override
  State<RoomNoticeListScreen> createState() => _RoomNoticeListScreenState();
}

class _RoomNoticeListScreenState extends State<RoomNoticeListScreen> {
  Future<List<ChallengeRoomNoticeResponse>?> getNoticeList() async =>
      ChallengeService.getNoticeList(roomId: widget.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getNoticeList(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const SizedBox();
            }
            List<ChallengeRoomNoticeResponse> noticeList = snapshot.data!;
            noticeList = [
              ChallengeRoomNoticeResponse(
                notiId: 2,
                roomId: 1,
                title: 'title',
                content: 'content',
                date: DateTime.now(),
              ),
              ChallengeRoomNoticeResponse(
                notiId: 2,
                roomId: 1,
                title: 'title',
                content: 'content',
                date: DateTime.now(),
              ),
              ChallengeRoomNoticeResponse(
                notiId: 2,
                roomId: 1,
                title: 'title',
                content: 'content',
                date: DateTime.now(),
              ),
            ];

            return ListView.builder(
              itemCount: noticeList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(noticeList[index].title),
                  children: [
                    Column(
                      children: [
                        Text(noticeList[index].content),
                        Text(DateFormat('yyyy.MM.dd a hh:mm', 'ko_KR')
                            .format(noticeList[index].date))
                      ],
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
