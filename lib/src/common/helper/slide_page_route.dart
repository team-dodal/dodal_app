import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget screen;

  SlidePageRoute({required this.screen})
      : super(
          pageBuilder: (context, animation, _) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: screen,
          ),
          transitionDuration: const Duration(milliseconds: 150),
          reverseTransitionDuration: const Duration(milliseconds: 150),
        );
}
