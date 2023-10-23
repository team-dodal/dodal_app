import 'package:dodal_app/theme/typo.dart';
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
      appBar: AppBar(
        title: Container(
          height: 42,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.bottom,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100),
                ),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100),
                ),
                suffixIcon: controller.text == ''
                    ? IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search))
                    : IconButton(
                        onPressed: () {
                          controller.text = '';
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
        ),
      ),
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
