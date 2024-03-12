import 'package:animations/animations.dart';
import 'package:dodal_app/src/common/enum/certification_code_enum.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/challenge/main/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/main/bloc/challenge_ranking_bloc.dart';
import 'package:dodal_app/src/challenge/main/page/challenge_chat_page.dart';
import 'package:dodal_app/src/challenge/main/page/chllenge_home_page.dart';
import 'package:dodal_app/src/challenge/main/page/challenge_ranking_page.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/challenge/widget/challenge_bottom_sheet.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Route extends Equatable {
  final String name;
  final Widget Function(ChallengeDetail challenge) screen;

  const Route({required this.name, required this.screen});

  @override
  List<Object?> get props => [name, screen];
}

List<Route> routeList = [
  Route(name: '홈', screen: (value) => ChallengeHomePage(challenge: value)),
  Route(
    name: '랭킹',
    screen: (value) => BlocProvider(
      create: (context) => ChallengeRankingBloc(value.id),
      child: RankingPage(challenge: value),
    ),
  ),
  Route(name: '채팅', screen: (value) => const ChallengeChatPage()),
];

class ChallengeMainPage extends StatefulWidget {
  const ChallengeMainPage({super.key});

  @override
  State<ChallengeMainPage> createState() => _ChallengeMainPageState();
}

class _ChallengeMainPageState extends State<ChallengeMainPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  void _routeMenuScreen(ChallengeDetail challenge) {
    context
        .push('/challenge/${challenge.id}/settings', extra: challenge)
        .then((value) {
      context.read<ChallengeInfoBloc>().add(LoadChallengeInfoEvent());
    });
  }

  void _certificateFeed(ChallengeDetail challenge) {
    context.push('/create-feed/${challenge.id}/${challenge.title}').then(
      (isNeedRefresh) {
        if (isNeedRefresh == true) {
          context.read<ChallengeInfoBloc>().add(LoadChallengeInfoEvent());
        }
      },
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: routeList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = context.watch<ChallengeInfoBloc>().state.result!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _routeMenuScreen(challenge);
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: routeList.map((route) => Tab(text: route.name)).toList(),
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        title: const Text('그룹'),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: routeList
            .map((route) => route.screen(challenge))
            .toList()[_currentIndex],
      ),
      bottomSheet: Builder(
        builder: (context) {
          if (_currentIndex == 0) {
            return Builder(
              builder: (context) {
                String text = '인증하기';
                Function()? onPress = () {
                  _certificateFeed(challenge);
                };
                if (challenge.todayCertCode == CertCode.success) {
                  text = '인증 완료';
                  onPress = null;
                }
                if (challenge.todayCertCode == CertCode.pending) {
                  text = '인증 대기중';
                  onPress = null;
                }
                return BlocProvider(
                  create: (context) => BookmarkBloc(
                    roomId: challenge.id,
                    isBookmarked: challenge.isBookmarked,
                  ),
                  child: ChallengeBottomSheet(
                    buttonText: text,
                    onPress: onPress,
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
