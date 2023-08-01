import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/services/category_service.dart';
import 'package:dodal_app/widgets/challenge_list/category_tab_bar.dart';
import 'package:flutter/material.dart';

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
  late TabController _tabController;
  List<Category> _categoryTabs = [];
  int _currentTabIndex = 0;

  _createCategoryTab() async {
    final categoryList = await CategoryService.getAllCategories();
    if (categoryList == null) return;
    _tabController = TabController(length: categoryList.length, vsync: this);
    final idx = categoryList.indexWhere(
        (category) => category.value == widget.selectedCategory.value);
    _tabController.index = idx;
    setState(() {
      _categoryTabs = categoryList;
      _currentTabIndex = idx;
    });
  }

  @override
  void initState() {
    _createCategoryTab();
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
          categoryTabs: _categoryTabs,
          categoryIndex: _currentTabIndex,
          onCategoryTab: (value) {
            setState(() {
              _currentTabIndex = value;
            });
          },
        ),
      ),
      body: Column(
        children: [Text('$_currentTabIndex')],
      ),
    );
  }
}
