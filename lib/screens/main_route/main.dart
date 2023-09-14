import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/screens/main_route/feed_screen.dart';
import 'package:dodal_app/screens/main_route/home_screen.dart';
import 'package:dodal_app/screens/main_route/mypage_screen.dart';
import 'package:dodal_app/screens/notification/main.dart';
import 'package:dodal_app/screens/settings_menu/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'challenge_screen.dart';

const List<Map<String, dynamic>> routes = [
  {
    'name': '홈',
    'icon': 'assets/icons/home_icon.svg',
    'activeIcon': 'assets/icons/home_active_icon.svg',
    'screen': HomeScreen(),
  },
  {
    'name': '피드',
    'icon': 'assets/icons/feed_icon.svg',
    'activeIcon': 'assets/icons/feed_active_icon.svg',
    'screen': FeedScreen(),
  },
  {
    'name': '도전',
    'icon': 'assets/icons/flag_icon.svg',
    'activeIcon': 'assets/icons/flag_active_icon.svg',
    'screen': ChallengeScreen(),
  },
  {
    'name': '마이',
    'icon': 'assets/icons/my_icon.svg',
    'activeIcon': 'assets/icons/my_active_icon.svg',
    'screen': MyPageScreen(),
  },
];

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _handleActionBtn(Widget screen) {
    Navigator.of(context).push(SlidePageRoute(screen: screen));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(routes.map((route) => route['name']).toList()[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {
                _handleActionBtn(const NotiFicationScreen());
              },
              icon: const Icon(Icons.notifications_none),
            ),
          if (_currentIndex == 2)
            IconButton(
              onPressed: () {
                _handleActionBtn(BlocProvider(
                  create: (context) => CreateChallengeCubit(),
                  child: const CreateChallengeScreen(),
                ));
              },
              icon: const Icon(Icons.add_rounded),
            ),
          if (_currentIndex == 3)
            IconButton(
              onPressed: () {
                _handleActionBtn(const SettingsMenuScreen());
              },
              icon: const Icon(Icons.settings),
            )
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: routes.map((route) => route['screen']).toList()[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          for (int i = 0; i < routes.length; i++)
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == i
                    ? routes[i]['activeIcon']
                    : routes[i]['icon'],
              ),
              label: routes[i]['name'],
            )
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
