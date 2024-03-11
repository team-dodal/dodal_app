import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CreateScreenLayout extends StatefulWidget {
  const CreateScreenLayout({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<CreateScreenLayout> createState() => _CreateScreenLayoutState();
}

class _CreateScreenLayoutState extends State<CreateScreenLayout> {
  bool _pageDirectionReverse = false;

  _dismissKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void didUpdateWidget(covariant CreateScreenLayout oldWidget) {
    if (oldWidget.currentIndex < widget.currentIndex) {
      _pageDirectionReverse = false;
    } else {
      _pageDirectionReverse = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dismissKeyboard(context);
      },
      child: PageTransitionSwitcher(
        reverse: _pageDirectionReverse,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: widget.children[widget.currentIndex],
      ),
    );
  }
}
