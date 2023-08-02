import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/services/category_service.dart';
import 'package:dodal_app/services/challenge_service.dart';
import 'package:dodal_app/widgets/challenge_list/category_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({
    super.key,
    required this.selectedCategory,
  });

  final Category selectedCategory;

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen>
    with TickerProviderStateMixin {
  static const _pageSize = 20;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);
  late TabController _tabController;
  List<Category> _categories = [];
  int _categoryIdx = 0;
  final int _tagIdx = 0;

  _createCategoryTab() async {
    final categoryList = await CategoryService.getAllCategories();
    if (categoryList == null) return;
    _tabController = TabController(length: categoryList.length, vsync: this);
    final idx = categoryList.indexWhere(
        (category) => category.value == widget.selectedCategory.value);
    _tabController.index = idx;
    setState(() {
      _categories = categoryList;
      _categoryIdx = idx;
    });
  }

  _request(int pageKey) {
    final res = ChallengeService.getChallengesByCategory(
      categoryValue: _categories[_categoryIdx].value,
      tagValue: _categories[_categoryIdx].tags[_tagIdx].value,
      conditionCode: 0,
      certCntList: [1, 2, 3, 4, 5, 6, 7],
      page: pageKey,
    );
    print(res);
  }

  @override
  void initState() {
    _createCategoryTab();
    _pagingController.addPageRequestListener((pageKey) {
      _request(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: CategoryTabBar(
          tabController: _tabController,
          categories: _categories,
          categoryIndex: _categoryIdx,
          tagIndex: _tagIdx,
          onCategoryTab: (value) {
            setState(() {
              _categoryIdx = value;
            });
          },
        ),
      ),
      body: Column(
        children: [Text('$_categoryIdx')],
      ),
    );
  }
}
