import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/search/bloc/search_history_list_cubit.dart';
import 'package:dodal_app/src/search/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.word});

  final String? word;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBarWidget(
          controller: controller,
          onSubmit: (value) {
            context.read<SearchHistoryListCubit>().addSearchItem(value);
            context.push('/search-result/$value');
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색어',
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: context.read<SearchHistoryListCubit>().removeAll,
                  child: const Text('전체 삭제'),
                ),
              ],
            ),
          ),
          BlocBuilder<SearchHistoryListCubit, List<String>>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 6,
                  children: [
                    for (final (index, word) in state.indexed)
                      _SearchItemButton(
                        text: word,
                        onTap: () {
                          context.push('/search-result/$word');
                        },
                        onCloseTap: () {
                          context
                              .read<SearchHistoryListCubit>()
                              .removeItem(index);
                        },
                      )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _SearchItemButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final Function()? onCloseTap;

  const _SearchItemButton({
    required this.text,
    this.onTap,
    this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.systemGrey3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: context.body4(color: AppColors.systemGrey1),
              ),
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: onCloseTap,
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.systemGrey2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
