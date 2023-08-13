import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '진행 중인 도전'),
            Tab(text: '운영 중인 도전'),
          ],
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 130),
              NoListContext(
                title: '운영 중인 도전이 없습니다.',
                subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
