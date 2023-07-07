import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

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
  ).apply(
    displayColor: AppColors.systemBlack,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
);
