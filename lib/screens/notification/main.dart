import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/services/alarm/response.dart';
import 'package:dodal_app/services/alarm/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiFicationScreen extends StatefulWidget {
  const NotiFicationScreen({super.key});

  @override
  State<NotiFicationScreen> createState() => _NotiFicationScreenState();
}

class _NotiFicationScreenState extends State<NotiFicationScreen> {
  List<AlarmResponse> _list = [];
  bool _isLoading = true;

  _deleteAlarmList() async {
    final userId = context.read<UserCubit>().state!.id;
    await AlarmService.deleteAllAlarmList(userId: userId);
    setState(() {
      _list = [];
    });
  }

  _getAlarmList() async {
    final userId = context.read<UserCubit>().state!.id;
    final res = await AlarmService.getAllAlarmList(userId: userId);
    if (res == null) return;
    setState(() {
      _isLoading = false;
      _list = res;
    });
  }

  @override
  void initState() {
    _getAlarmList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('알림'),
          actions: [
            TextButton(
              onPressed: _deleteAlarmList,
              child: const Text('알림 삭제'),
            )
          ],
        ),
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (_list.isEmpty) {
              return const Column(
                children: [
                  SizedBox(height: 100),
                  Center(child: NoListContext(title: '알림이 없습니다')),
                ],
              );
            }
            return ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return AlarmContainer(item: _list[index]);
              },
            );
          },
        )
        // FutureBuilder(
        //   future: AlarmService.getAllAlarmList(
        //     userId: BlocProvider.of<UserCubit>(context).state!.id,
        //   ),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CupertinoActivityIndicator(),
        //       );
        //     }

        //     List<AlarmResponse> list = snapshot.data!;
        //     if (list.isEmpty) {
        //       return const Column(
        //         children: [
        //           SizedBox(height: 100),
        //           Center(child: NoListContext(title: '알림이 없습니다')),
        //         ],
        //       );
        //     } else {
        //       return ListView.builder(
        //         itemCount: list.length,
        //         itemBuilder: (context, index) {
        //           return AlarmContainer(item: list[index]);
        //         },
        //       );
        //     }
        //   },
        // ),
        );
  }
}

class AlarmContainer extends StatelessWidget {
  const AlarmContainer({
    super.key,
    required this.item,
  });

  final AlarmResponse item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // icon
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: context.body4(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.registerCode,
                      style: context.caption(
                        color: AppColors.systemGrey1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      item.content,
                      style: context.body4(
                        color: AppColors.systemGrey1,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
