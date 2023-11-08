import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/search/search_bar.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 겁색어',
                style: context.body1(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('전체 삭제'))
            ],
          )
        ],
      ),
    );
  }
}
