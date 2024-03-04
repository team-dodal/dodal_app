import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/notification_list_bloc.dart';
import 'package:dodal_app/services/alarm/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiFicationScreen extends StatelessWidget {
  const NotiFicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<NotificationListBloc>()
                  .add(ClearNotificationListEvent());
            },
            child: const Text('알림 삭제'),
          )
        ],
      ),
      body: BlocBuilder<NotificationListBloc, NotificationListState>(
        builder: (context, state) {
          if (state.status == CommonStatus.loaded) {
            if (state.list.isEmpty) {
              return const Column(
                children: [
                  SizedBox(height: 100),
                  Center(child: NoListContext(title: '알림이 없습니다')),
                ],
              );
            }

            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return AlarmContainer(item: state.list[index]);
              },
            );
          }

          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}

class AlarmContainer extends StatelessWidget {
  const AlarmContainer({super.key, required this.item});

  final AlarmResponse item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: context.body4(fontWeight: FontWeight.bold),
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
                      style: context.body4(color: AppColors.systemGrey1),
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
