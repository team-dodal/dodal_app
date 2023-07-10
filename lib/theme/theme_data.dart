import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Pretendard',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // headline1
    headlineMedium: TextStyle(
      fontSize: 24,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // headline2
    headlineSmall: TextStyle(
      fontSize: 22,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // headline3
    titleLarge: TextStyle(
      fontSize: 20,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // headline4
    titleMedium: TextStyle(
      fontSize: 18,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // body1
    titleSmall: TextStyle(
      fontSize: 16,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // body2
    bodyLarge: TextStyle(fontSize: 15, letterSpacing: 0.5), // body3
    bodyMedium: TextStyle(
      fontSize: 14,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // body4
    bodySmall: TextStyle(
      fontSize: 12,
      letterSpacing: 0.5,
      color: AppColors.systemBlack,
    ), // caption
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: AppColors.bgColor1,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.systemBlack,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.orange,
      foregroundColor: AppColors.bgColor1,
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.bgColor1,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.bgColor1,
      foregroundColor: AppColors.orange,
      side: BorderSide.none,
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      disabledBackgroundColor: AppColors.bgColor1,
      disabledForegroundColor: AppColors.systemGrey2,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange)
      .copyWith(background: AppColors.bgColor1, primary: AppColors.orange),
);
