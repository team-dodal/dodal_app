import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/bloc/category_list_bloc.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/search/page/search_result_page.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/search/widget/search_bar.dart';
import 'package:dodal_app/src/search/widget/search_item_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.word});

  final String? word;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<String> _list = [];

  getSearchList() async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('search_list');
    if (list == null) {
      pref.setStringList('search_list', []);
      setState(() {
        _list = [];
      });
    } else {
      setState(() {
        _list = list;
      });
    }
  }

  addSearchItem(String word) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('search_list');
    if (list == null) return;
    final newList = [word, ...list];
    if (newList.length >= 20) {
      newList.removeLast();
    }
    pref.setStringList('search_list', newList);
    setState(() {
      _list = newList;
    });
  }

  removeList() async {
    final pref = await SharedPreferences.getInstance();
    pref.setStringList('search_list', []);
    setState(() {
      _list = [];
    });
  }

  goResultScreen(String word) {
    if (!mounted) return;
    List<Category> list =
        context.read<CategoryListBloc>().state.categoryListForFilter();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (ctx) => ChallengeListFilterCubit(category: list[0]),
          child: SearchResultPage(word: word),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.word != null) {
      controller.text = widget.word!;
    }
    getSearchList();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBarWidget(
          controller: controller,
          onSubmit: (value) async {
            await addSearchItem(value);
            goResultScreen(value);
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
                  onPressed: () async {
                    await removeList();
                  },
                  child: const Text('전체 삭제'),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              children: [
                for (String word in _list)
                  SearchItemButton(
                    text: word,
                    onTap: () {
                      goResultScreen(word);
                    },
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
