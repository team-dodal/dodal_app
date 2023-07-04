import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/screens/main_route/feed_screen.dart';
import 'package:dodal_app/screens/main_route/home_screen.dart';
import 'package:dodal_app/screens/main_route/mypage_screen.dart';
import 'package:dodal_app/screens/notification/main.dart';
import 'package:dodal_app/screens/settings_menu/main.dart';
import 'package:flutter/material.dart';
import '../../model/navigation_route.dart';
import '../../services/user_service.dart';
import '../../utilities/fcm.dart';
import 'group_screen.dart';

final List<NavigationRoute> _routes = [
  NavigationRoute(
    name: '홈',
    icon: const Icon(Icons.home),
    screen: const HomeScreen(),
  ),
  NavigationRoute(
    icon: const Icon(Icons.feed),
    name: '피드',
    screen: const FeedScreen(),
  ),
  NavigationRoute(
    name: '그룹',
    screen: const GroupScreen(),
    icon: const Icon(Icons.group),
  ),
  NavigationRoute(
    name: '마이페이지',
    icon: const Icon(Icons.person),
    screen: const MyPageScreen(),
  ),
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
  void initState() {
    UserService.updateFcmToken(Fcm.token!);
    super.initState();
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
        title: Text(_routes.map((route) => route.name).toList()[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {
                _handleActionBtn(const NotiFicationScreen());
              },
              icon: const Icon(Icons.notifications_none),
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
        child: _routes.map((route) => route.screen).toList()[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _routes
            .map((route) =>
                BottomNavigationBarItem(icon: route.icon!, label: route.name))
            .toList(),
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
