import 'package:flutter/material.dart';

class Typo {
  BuildContext context;
  Typo(this.context);

  TextStyle? headline1() => Theme.of(context).textTheme.displayLarge;
  TextStyle? headline2() => Theme.of(context).textTheme.headlineMedium;
  TextStyle? headline3() => Theme.of(context).textTheme.headlineSmall;
  TextStyle? headline4() => Theme.of(context).textTheme.titleLarge;
  TextStyle? body1() => Theme.of(context).textTheme.titleMedium;
  TextStyle? body2() => Theme.of(context).textTheme.titleSmall;
  TextStyle? body3() => Theme.of(context).textTheme.bodyLarge;
  TextStyle? body4() => Theme.of(context).textTheme.bodyMedium;
  TextStyle? caption() => Theme.of(context).textTheme.bodySmall;
}

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
  useMaterial3: true,
  fontFamily: 'Pretendard',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 28, letterSpacing: 0.5), // headline1
    headlineMedium: TextStyle(fontSize: 24, letterSpacing: 0.5), // headline2
    headlineSmall: TextStyle(fontSize: 22, letterSpacing: 0.5), // headline3
    titleLarge: TextStyle(fontSize: 20, letterSpacing: 0.5), // headline4
    titleMedium: TextStyle(fontSize: 18, letterSpacing: 0.5), // body1
    titleSmall: TextStyle(fontSize: 16, letterSpacing: 0.5), // body2
    bodyLarge: TextStyle(fontSize: 15, letterSpacing: 0.5), // body3
    bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.5), // body4
    bodySmall: TextStyle(fontSize: 12, letterSpacing: 0.5), // caption
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
);
