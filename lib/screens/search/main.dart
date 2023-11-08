import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/search/search_bar.dart';
import 'package:dodal_app/widgets/search/search_item_button.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SearchBarWidget(controller: controller)),
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
                TextButton(onPressed: () {}, child: const Text('전체 삭제'))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              children: [SearchItemButton(text: '러닝')],
            ),
          )
        ],
      ),
    );
  }
}
