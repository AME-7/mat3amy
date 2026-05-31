import 'package:flutter/material.dart';
import 'package:mat3amy/core/constants/app_fonts.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

abstract class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: AppFonts.cairo,
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      centerTitle: true,
      foregroundColor: AppColors.whiteColor,
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.cairo,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    dividerColor: Colors.transparent,
    dividerTheme: DividerThemeData(color: AppColors.borderColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(60, 30),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.body16.copyWith(color: AppColors.greyColor),
      fillColor: AppColors.accentColor,
      filled: true,
      prefixIconColor: AppColors.primaryColor,
      suffixIconColor: AppColors.primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.greyColor,
      backgroundColor: Colors.transparent,
      selectedLabelStyle: AppTextStyles.caption12.copyWith(
        fontWeight: FontWeight.w600,
        height: 2,
      ),
      unselectedLabelStyle: AppTextStyles.caption12.copyWith(
        fontWeight: FontWeight.w600,
        height: 2,
      ),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      // text color
      onSurface: AppColors.darkColor,
    ),
  );
}
