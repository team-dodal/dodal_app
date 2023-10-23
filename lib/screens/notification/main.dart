import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/services/alarm/response.dart';
import 'package:dodal_app/services/alarm/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiFicationScreen extends StatelessWidget {
  const NotiFicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: FutureBuilder(
        future: AlarmService.getAllAlarmList(
          userId: BlocProvider.of<UserCubit>(context).state!.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<AlarmResponse> list = snapshot.data!;
          if (list.isEmpty) {
            return const Column(
              children: [
                SizedBox(height: 100),
                Center(child: NoListContext(title: '알림이 없습니다')),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return AlarmContainer(item: list[index]);
              },
            );
          }
        },
      ),
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
                      '1시간 전',
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
