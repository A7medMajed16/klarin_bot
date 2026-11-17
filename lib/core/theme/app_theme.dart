import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/app_strings.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_widget_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      dayStyle: 16.medium,
      weekdayStyle: 16.medium,
      backgroundColor: AppColors.originalWhite,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.originalWhite,
    primaryColor: AppColors.primerColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
    useMaterial3: true,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppTypography.getTextColorFor(Brightness.light),
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppTypography.getTextColorFor(Brightness.light),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppTypography.getTextColorFor(Brightness.light),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.primerColor.withValues(alpha: 0.05),
      shadowColor: AppColors.primerColor.withValues(alpha: 0.25),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primerColor,
      brightness: Brightness.light,
      primary: AppColors.primerColor,
      onPrimary: Colors.white,
      secondary: AppColors.primerColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primerColor,
      selectionColor: AppColors.primerColor.withValues(alpha: 0.25),
      selectionHandleColor: AppColors.primerColor,
    ),
    fontFamily: AppStrings.arabicFontFamily,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xffffffff),
      contentPadding: const EdgeInsets.all(14.0),
      isDense: true,
      hintStyle: const TextStyle(color: Color(0xff9E9E9E)),
      labelStyle: const TextStyle(color: Color(0xff9E9E9E)),
      focusColor: AppColors.primerColor,
      floatingLabelStyle: const TextStyle(
        color: AppColors.primerColor,
        fontSize: 18,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xffDBDBDB),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color(0xffDBDBDB),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: AppColors.primerColor.withValues(alpha: 0.6),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppWidgetTheme.errorBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          AppColors.primerColor,
        ),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        overlayColor: WidgetStateProperty.all<Color>(Colors.black26),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primerColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.originalWhite,
      dragHandleColor: AppWidgetTheme.scrollbarThumbColor,
      dragHandleSize: Size(36, 4),

      shape: RoundedRectangleBorder(borderRadius: .circular(999)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      backgroundColor: const Color(0xFF1A1D27),
    ),
    datePickerTheme: DatePickerThemeData(
      dayStyle: 16.medium,
      weekdayStyle: 16.medium,
      backgroundColor: const Color(0xFF1A1D27),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black0D,
    primaryColor: AppColors.primerColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
    useMaterial3: true,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppTypography.getTextColorFor(Brightness.dark),
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppTypography.getTextColorFor(Brightness.dark),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppTypography.getTextColorFor(Brightness.dark),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1D27),
      shadowColor: Colors.black.withValues(alpha: 0.5),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primerColor,
      brightness: Brightness.dark,
      primary: AppColors.primerColor,
      onPrimary: Colors.white,
      secondary: AppColors.primerColor,
      onSecondary: Colors.white,
      surface: const Color(0xFF1A1D27),
      onSurface: const Color(0xFFE5E7EB),
      error: const Color(0xFFCF6679),
      onError: Colors.black,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primerColor,
      selectionColor: AppColors.primerColor.withValues(alpha: 0.25),
      selectionHandleColor: AppColors.primerColor,
    ),
    fontFamily: AppStrings.arabicFontFamily,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF252833),
      contentPadding: const EdgeInsets.all(14.0),
      isDense: true,
      hintStyle: const TextStyle(color: Color(0xff9E9E9E)),
      labelStyle: const TextStyle(color: Color(0xff9E9E9E)),
      focusColor: AppColors.primerColor,
      floatingLabelStyle: const TextStyle(
        color: AppColors.primerColor,
        fontSize: 18,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xff3C4043),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color(0xff3C4043),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: AppColors.primerColor.withValues(alpha: 0.6),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppWidgetTheme.errorBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          AppColors.primerColor,
        ),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        overlayColor: WidgetStateProperty.all<Color>(Colors.white24),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primerColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.black0D,
      dragHandleColor: AppWidgetTheme.scrollbarThumbColor,
      dragHandleSize: Size(36, 4),
      shape: RoundedRectangleBorder(borderRadius: .circular(999)),
    ),
  );
}
